# frozen_string_literal: true

module CoreExtensions
  module ActiveRecord
    module SchemaCache
      # Filling the whole cache (for example `db:schema:cache:dump`) asks for the columns
      # and primary keys of every table. For ClickHouse, read them all in one request
      # instead of two requests per table. Other adapters are not affected.
      def add_all(pool)
        pool.with_connection do |connection|
          next super(pool) unless connection.respond_to?(:with_bulk_schema_load)

          connection.with_bulk_schema_load { super(pool) }
        end
      end
    end
  end
end
