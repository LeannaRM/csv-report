require 'csv'

require 'pry'


inputNames = ARGV


def csvToHash(accountName)
	hashStandardizedData = Hash.new


	CSV.foreach("accounts.csv", {headers: true, return_headers: false}) do |row|
	    if row["Account"] == "Sonia\n"
    		row["Account"] = "Sonia"
    	end
    	if row["Category"] == "Groceries\n"
    		row["Category"] = "Groceries"
    	end

	    if row["Account"] == accountName
			
			# TODO These 4 lines can become 2. Look into regular expressions.
			outflow = row["Outflow"].delete ","
			inflow = row["Inflow"].delete ","
			outflow = outflow.delete "$"
			inflow = inflow.delete "$"

			moneyarray = Array.new
			moneyarray << inflow.to_f - outflow.to_f

			if hashStandardizedData.has_key?(row["Category"])
				newarray = hashStandardizedData[row["Category"]].concat(moneyarray)
				hashStandardizedData[row["Category"]] = newarray
			else
				hashStandardizedData[row["Category"]] = moneyarray
			end


		end
	end

	return hashStandardizedData

end

k = 0
while k < inputNames.length 

	hashStandardizedData2 = csvToHash(inputNames[k])

	categoryTotal = []
	category = []
	# category = {} # Or Hash.new
	# {
	# 	"Entertainment" => {"sum" => 200, "average" => 23},
	# 	"Utilities" => {"sum" => 220, "average" => 20}
	# }
	categoryAverage =[]

	# { and } can be replaced with do and end.
	# hashStandardizedData2.each {|key, value| category[key] = value.sum }

	hashStandardizedData2.each_value{|value|categoryTotal << value.sum}
	hashStandardizedData2.each_key{|key|category << key}
	hashStandardizedData2.each_value{|value|categoryAverage << value.sum/value.length}

	# TODO Integrate these operations into one loop above.
	categoryTotal.map! {|x| x.round(2)}
	categoryAverage.map! {|x| x.round(2)}

	balance = categoryTotal.sum

	categoryTotal.map! {|x| x.to_s}




	############### DISPLAY
	puts "============================================================\n"
	puts "Account: " + inputNames[k] + "... Balance: $" + balance.to_s + "\n"
	puts "============================================================\n"
	i = 0

	longestCategoryLength = category.max_by{|x| x.length}.length
	longestTotallength = categoryTotal.max_by{|x| x.length}.length

	puts "Category" + "\t\t|" + "Total Spent" + "\t|" + "Average Transaction"

	puts "------------------------|---------------|----------------"


	while i < category.length do
		while category[i].length < longestCategoryLength
			category[i] = category[i] + " "
		end
		while categoryTotal[i].length < longestTotallength
			categoryTotal[i] = categoryTotal[i] + " "
		end

		puts category[i].to_s + "\t\t|" + categoryTotal[i] + "\t|" + categoryAverage[i].to_s
		i += 1
	end
	k += 1
end









