require_relative "data_cleaner"

module ReportGenerator
  TRANSACTION_DETAIL_FIELDS = %w[
    date
    country
    channel
    category
    shop_name
    shop_city
    units_sold
    revenue
    transactions
  ].freeze

  STORE_SUMMARY_FIELDS = %w[
    shop_name
    shop_city
    total_units_sold
    total_revenue
    total_transactions
  ].freeze

  def self.generate_detail(transactions, stores)
    store_lookup = build_store_lookup(stores)

    transactions.map do |transaction|
      shop_id = DataCleaner.parse_string(transaction["shop_id"])
      shop = store_lookup[shop_id]

      {
        "shop_id" => shop_id,
        "date" => DataCleaner.format_date(transaction["date"]),
        "country" => DataCleaner.parse_string(transaction["country"]),
        "channel" => DataCleaner.parse_string(transaction["channel"]),
        "category" => DataCleaner.parse_string(transaction["category"]),
        "shop_name" => DataCleaner.parse_string(shop&.[]("name")),
        "shop_city" => DataCleaner.parse_string(shop&.[]("city")),
        "units_sold" => DataCleaner.parse_int(transaction["units_sold"]),
        "revenue" => DataCleaner.parse_float(transaction["revenue"]),
        "transactions" => DataCleaner.parse_int(transaction["transactions"])
      }
    end
  end

  def self.generate_store_summary(detail_rows)
    groups = detail_rows.group_by do |row|
      row["shop_id"]
    end

    groups.map do |_shop_id, rows|
      {
        "shop_name" => rows.first["shop_name"],
        "shop_city" => rows.first["shop_city"],
        "total_units_sold" => rows.sum { |row| row["units_sold"].to_i },
        "total_revenue" => rows.sum { |row| row["revenue"].to_f },
        "total_transactions" => rows.sum { |row| row["transactions"].to_i }
      }
    end
  end

  def self.build_store_lookup(stores)
    stores.to_h do |store|
      [
        DataCleaner.parse_string(store["shop_id"]),
        store
      ]
    end
  end

  private_class_method :build_store_lookup

end
