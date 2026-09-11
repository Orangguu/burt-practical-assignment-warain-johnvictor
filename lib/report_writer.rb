require "csv"

module ReportWriter
  def self.write_transaction(rows, filename)
    CSV.open(filename, "wb") do |csv|
      csv << ReportGenerator::TRANSACTION_DETAIL_FIELDS

      rows.each do |row|
        csv << ReportGenerator::TRANSACTION_DETAIL_FIELDS.map do |field|
          row[field].nil? ? "N/A" : row[field]
        end
      end
    end
  end

  def self.write_summary(rows, filename)
    CSV.open(filename, "wb") do |csv|
      csv << ReportGenerator::STORE_SUMMARY_FIELDS

      rows.each do |row|
        csv << ReportGenerator::STORE_SUMMARY_FIELDS.map do |field|
          row[field].nil? ? "N/A" : row[field]
        end
      end
    end
  end
end
