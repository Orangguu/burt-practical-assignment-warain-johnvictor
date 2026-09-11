# burt-practical-assignment-warain-johnvictor

Practical assignment featuring a daily sales report.

main.rb - runs the scripts. It loads the json, cleans transaction data, generates the report, and writes the csv file.

lib/data_loader.rb - handles the loading and parsing of the json file. Throws errors for invalid or missing files.

lib/data_cleaner.rb - handles the cleaning and formatting of input. It handles strings, integers, floats, and dates. Invalid input are replaced with nil values.

lib/report_generator.rb - contains the main report logic. It matches transactions with their corresponding stores using shop_id, creates the transaction detail data, and calculates the total revenue, units sold, and transactions for the store summary.

lib/report_writer.rb - handles creating the CSV files. It defines the required column order and converts missing values (nil) to "N/A" in the final reports. Reports are stored in the output/ directory

tests/data_cleaner_test.rb - Tests the expected behavior when handling and cleaning raw input values.

tests/report_generator_test.rb - Tests the expected behavior of generating transaction detail and store summary reports.

tests/report_writer_test.rb - Tests the expected behavior of writing the generated reports to CSV, including converting missing values (nil) to "N/A".

## Setup

This project uses Ruby 3.4 and Bundler. The .ruby-version file indicates the Ruby version, and the Gemfile defines the test dependency.

Install Ruby 3.4, then run:

```bash
gem install bundler
bundle install
```

# Run the program
bundle exec ruby main.rb

# Run tests individually
bundle exec ruby tests/data_cleaner_test.rb
bundle exec ruby tests/report_generator_test.rb
bundle exec ruby tests/report_writer_test.rb