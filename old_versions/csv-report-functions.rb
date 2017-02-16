require 'csv'

require 'pry'

def take_off_next_line(row)
	if row["Account"] == "Sonia\n"
		row["Account"] = "Sonia"
	end
	if row["Category"] == "Groceries\n"
		row["Category"] = "Groceries"
	end
	return row
end


def cleanUpAndCalculate(row)
	outflow = row["Outflow"].delete(",").delete("$")
	inflow = row["Inflow"].delete(",").delete("$")
	return inflow.to_f - outflow.to_f	
end



def fillHash(hashStandardizedData, row, moneyamount)
	if hashStandardizedData.has_key?(row["Category"])
		newarray = hashStandardizedData[row["Category"]].push(moneyamount)
		hashStandardizedData[row["Category"]] = newarray
	else
		hashStandardizedData[row["Category"]] = [moneyamount]
	end
	return hashStandardizedData
end

def csvToHash(accountName)
	hashStandardizedData = Hash.new

	CSV.foreach("accounts.csv", {headers: true, return_headers: false}) do |row|
    	row = take_off_next_line(row)
	    if row["Account"] == accountName
			moneyamount = cleanUpAndCalculate(row)
			hashStandardizedData = fillHash(hashStandardizedData, row, moneyamount)
		end
	end
	return hashStandardizedData
end

def calculateSumAverage(hashStandardizedData2)
	categorysumaverage = {}

	hashStandardizedData2.each do |key, value|
		categorysumaverage[key] = [value.sum.round(2), (value.sum/value.length).round(2)]
	end
	return categorysumaverage
end

def createSpacing(categorysumaverage)
	longestCategoryLength = categorysumaverage.keys.max_by{|x| x.length}.length	
	longestTotallength = categorysumaverage.values.transpose[0].max_by{|x| x.to_s.length}.to_s.length
	hashWithSpacing = {}
	categorysumaverage.each do |key, value|
		while key.length < longestCategoryLength
			key = key + " "
		end
		while value[0].to_s.length < longestTotallength
			value[0] = value[0].to_s + " "
		end
		hashWithSpacing[key] = value
	end
	return hashWithSpacing
end

def displayOnScreen(categorysumaverage, inputName, balance)
	puts "============================================================\n"
	puts "Account: " + inputName + "... Balance: $" + balance + "\n"
	puts "============================================================\n"
	puts "Category" + "\t\t|" + "Total Spent" + "\t|" + "Average Transaction"
	puts "------------------------|---------------|----------------"
	categorysumaverage.each{|key, value| puts key + "\t\t|" + value[0].to_s + "\t|" + value[1].to_s}
	return
end

def calculateBalance(categorysumaverage)
	balance = 0
	categorysumaverage.each_value{|value| balance+=value[0]}
	balance = balance.round(2).to_s
	return balance
end

def createReportOnScreen(inputName)
	hashStandardizedData2 = csvToHash(inputName)

	categorysumaverage = calculateSumAverage(hashStandardizedData2)

	balance = calculateBalance(categorysumaverage)

	categorysumaverage = createSpacing(categorysumaverage)

	displayOnScreen(categorysumaverage, inputName, balance)
	return
end

def displayHTML(categorysumaverage, inputName, balance)
	puts "<h1>" + inputName + "</h1>"
	puts "<p>Total Balance: $" + balance + "</p>"
	puts "<hr>"
	puts "<table>"
	puts "\t<tr>"
	puts "\t\t<td>Category</td>"
	puts "\t\t<td>Total Spent</td>"
	puts "\t\t<td>Average Transaction</td>"
	puts "\t</tr>"

	categorysumaverage.each do |key, value| 
		puts "\t<tr>"
		puts "\t\t<td>" + key + "</td>"
		puts "\t\t<td>" + value[0].to_s + "</td>"
		puts "\t\t<td>" + value[1].to_s + "</td>"
		puts "\t</tr>"
	end
	puts "</table>"
end

def createReportHTML(inputName)

	hashStandardizedData2 = csvToHash(inputName)

	categorysumaverage = calculateSumAverage(hashStandardizedData2)

	balance = calculateBalance(categorysumaverage)

	displayHTML(categorysumaverage, inputName, balance)

	return
end

def outputCSV(categorysumaverage, inputName, balance)
	
	filename = inputName + ".csv"

	CSV.open(filename, 'w') { |f|
  		f.puts  ["Category", "Total Spent", "Average Transaction"]
  		categorysumaverage.each do |key, value|
  			f.puts [key, value[0], value[1]]
  		end
	}
	return 
end

def createReportCSV(inputName)

	hashStandardizedData2 = csvToHash(inputName)

	categorysumaverage = calculateSumAverage(hashStandardizedData2)

	balance = calculateBalance(categorysumaverage)

	outputCSV(categorysumaverage, inputName, balance)

	return
end

inputNames = ARGV

k = 0

while k < inputNames.length 

	createReportOnScreen(inputNames[k])

	#createReportHTML(inputNames[k])

	createReportCSV(inputNames[k])

	k += 1
end



