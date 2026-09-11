require "fileutils"

require_relative "lib/data_loader"
require_relative "lib/report_generator"
require_relative "lib/report_writer"

root_dir = __dir__
data_dir = File.join(root_dir, "data")
output_dir = File.join(root_dir, "output")

stores = DataLoader.load_json(File.join(data_dir, "stores.json"))
transactions = DataLoader.load_json(File.join(data_dir, "transactions.json"))

detail_rows = ReportGenerator.generate_detail(transactions, stores)
summary_rows = ReportGenerator.generate_store_summary(detail_rows)

FileUtils.mkdir_p(output_dir)
ReportWriter.write_transaction(
	detail_rows,
	File.join(output_dir, "transaction_detail_report.csv")
)
ReportWriter.write_summary(
	summary_rows,
	File.join(output_dir, "store_summary_report.csv")
)

puts "Reports generated in #{output_dir}"