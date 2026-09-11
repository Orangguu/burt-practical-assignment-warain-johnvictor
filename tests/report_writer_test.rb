require "minitest/autorun"
require "tempfile"
require_relative "../lib/report_generator"
require_relative "../lib/report_writer"

class ReportWriterTest < Minitest::Test
	def test_writes_na_for_unexpected_and_missing_values
		rows = [{
			"date" => nil,
			"country" => "Philippines",
			"channel" => "Online",
			"category" => nil,
			"shop_name" => "UPTC",
			"shop_city" => "Manila",
			"units_sold" => nil,
			"revenue" => nil,
            # Missing transactions row
		}]

		Tempfile.create(["transactions", ".csv"]) do |file|
			ReportWriter.write_transaction(rows, file.path)

			output = CSV.read(file.path)
			assert_equal ["N/A", "Philippines", "Online", "N/A", "UPTC", "Manila", "N/A", "N/A", "N/A"], output[1]
		end
	end
end
