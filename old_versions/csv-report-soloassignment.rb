require 'csv'

require 'pry'

class AccountClass

	def initial_values
		@categoryData = {}
		@balance = 0
	end

	def addCategory(row)
		@categoryData[row["Category"].chomp] = DataClass.new
		@categoryData[row["Category"].chomp].initial_values
	end

	def addData(row)
		@categoryData[row["Category"].chomp].addData(row)
	end

	def calculateFinalAmounts
		@categoryData.each_value do |value| 
			value.calculateFinalValues
			@balance = (@balance + value.getTotal).round(2)
		end
	end

	def getCategoryData
		return @categoryData
	end

	def getBalance
		return @balance
	end

	#Next three for getting spacing right for in terminal printing
	def calculateLongestTotal
		@longestTotalLength = 0
		@categoryData.each_value do |value| 
			if @longestTotalLength < value.getTotal.to_s.length
				@longestTotalLength = value.getTotal.to_s.length
			end
		end
	end

	def calculateLongestCategory
		@longestCategoryLength = 0
		@categoryData.each_key do |key| 
			if @longestCategoryLength < key.length
				@longestCategoryLength = key.length
			end
		end
	end

	def spaceData
		@categoryDataWithSpacing = {}
		@categoryData.each do |key, value|
			
			while key.length < @longestCategoryLength
			 	key = key + " "
			end
			value.spaceTotals(@longestTotalLength)
			@categoryDataWithSpacing[key] = value
		end
		return @categoryDataWithSpacing
	end

end




class DataClass
	def initial_values
		@transactions = []
	end

	def addData(row)
		@inflow = row["Inflow"].delete(",").delete("$").to_f
		@outflow = row["Outflow"].delete(",").delete("$").to_f
		@transactions << @inflow - @outflow
	end

	def calculateFinalValues
		@categoryTotal = @transactions.sum.round(2)
		@categoryAverage = (@transactions.sum/@transactions.length).round(2)
	end

	def getTotal
		return @categoryTotal
	end

	def getAverage
		return @categoryAverage
	end

	def spaceTotals(longestTotalLength)
		while @categoryTotal.to_s.length < longestTotalLength
				@categoryTotal = @categoryTotal.to_s + " "
		end
	end

end




#function to set initial values for new categories and accounts
def set_initial_values(accountsHash,name,row)
	unless accountsHash.has_key?(name)
		accountsHash[name] = AccountClass.new
		accountsHash[name].initial_values
	end
	unless accountsHash[name].getCategoryData.has_key?(row["Category"].chomp)
		accountsHash[name].addCategory(row)
	end
	return accountsHash
end

#Main function that calls the other to get data read in and organized
def csvAccountDataParsing
	accounts = {}

	CSV.foreach("accounts.csv", {headers: true, return_headers: false}) do |row|
		accountName = row["Account"].chomp.capitalize
		accounts = set_initial_values(accounts, accountName, row)
		accounts[accountName].addData(row)
	end

	accounts.each_value do |value|
		value.calculateFinalAmounts
	end




	return accounts
end

def testfunction(accounts, expected)

	def test_sum(expected, actual)
		if expected == actual
			puts "Pass"
		else
			puts "Fail. Expected #{expected}, but got #{actual}"
		end
	end

	test_sum(expected, accounts["Sonia"].getBalance)

end






################# FOR OUTPUT AND DISPLAY BELOW ################


def createReportInTerminal(accountClass, name)
	#create spacing
	accountClass.calculateLongestCategory
	accountClass.calculateLongestTotal
	accountClass.spaceData

	puts "============================================================\n"
	puts "Account: " + name.capitalize + "... Balance: $" + accountClass.getBalance.to_s + "\n"
	puts "============================================================\n"
	puts "Category" + "\t\t|" + "Total Spent" + "\t|" + "Average Transaction"
	puts "------------------------|---------------|----------------"
	accountClass.spaceData.each{|key, value| puts key + "\t\t|" + value.getTotal.to_s + "\t|" + value.getAverage.to_s}
	return

end


def createReportHTML(accountClass, name)
	puts "<h1>" + name.capitalize + "</h1>"
	puts "<p>Total Balance: $" + accountClass.getBalance.to_s + "</p>"
	puts "<hr>"
	puts "<table>"
	puts "\t<tr>"
	puts "\t\t<td>Category</td>"
	puts "\t\t<td>Total Spent</td>"
	puts "\t\t<td>Average Transaction</td>"
	puts "\t</tr>"

	accountClass.getCategoryData.each do |key, value| 
		puts "\t<tr>"
		puts "\t\t<td>" + key + "</td>"
		puts "\t\t<td>" + value.getTotal.to_s + "</td>"
		puts "\t\t<td>" + value.getAverage.to_s + "</td>"
		puts "\t</tr>"
	end
	puts "</table>"
end


def createReportCSV(accountClass, name)
	
	filename = name.capitalize + ".csv"

	CSV.open(filename, 'w') { |f|
  		f.puts  ["Category", "Total Spent", "Average Transaction"]
  		accountClass.getCategoryData.each do |key, value|
  			f.puts [key, value.getTotal, value.getAverage]
  		end
	}
	return 
end



########## For each name and type of output ##########

inputNames = ARGV

k = 0

data = csvAccountDataParsing

#expectedResults = balance
expectedResults = 3094.76

testfunction(data, expectedResults)


holdingArray = Array.new
ways = ["csv", "CSV", "HTML", "html"]
ways.each do |i|
	holdingArray << inputNames.delete(i)
end

while k < inputNames.length 
	if data[inputNames[k].capitalize] == nil
		puts inputNames[k] + " is not included in the csv file! Try again."
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



