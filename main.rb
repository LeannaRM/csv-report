require 'csv'

require 'pry'

require_relative "./functions.rb"

binding.pry
inputNames = ARGV

k = 0
data = csvAccountDataParsing


holdingArray = Array.new
ways = ["csv", "CSV", "HTML", "html"]
ways.each do |i|
	holdingArray << inputNames.delete(i)
end

if inputNames == []
	puts "You need to type a name!"
end

while k < inputNames.length 
	if data[inputNames[k].capitalize] == nil
		puts inputNames[k] + " is not included in the csv file!"
		puts "Try: " + data.keys.to_s
		k += 1
	else	
		currentAccountData = data[inputNames[k].capitalize]
		if holdingArray.include?("html") || holdingArray.include?("HTML")
			createReportHTML(currentAccountData, inputNames[k])
		end
		if holdingArray.include?("csv") || holdingArray.include?("CSV")
			createReportCSV(currentAccountData, inputNames[k])
		end
		createReportInTerminal(currentAccountData, inputNames[k])
		k += 1

	end
end


