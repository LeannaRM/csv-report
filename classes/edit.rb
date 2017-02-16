require 'csv'
require 'pry'

#load accounts.csv file into program
class AccountByTransaction
	def setup
		@accountname = ""
		@arrayOfTransactions = []
		@arrayOfTransactionsUser = []
		self.loadArray
	end

	def loadArray
		CSV.foreach('accounts.csv', {headers:true}) do |row|
			row["Account"] = row["Account"].chomp
			row["Category"] = row["Category"].chomp
			row["Payee"] = row["Payee"].chomp
			row["Inflow"] = row["Inflow"].delete(",")
			row["Outflow"] = row["Outflow"].delete(",")
			@arrayOfTransactions << row.to_s
		end
	end

	def returnTransactions(name)
		if @arrayOfTransactionsUser == []
			@arrayOfTransactions.each do |transaction|
				if name.capitalize == transaction.split(",")[0]
					@arrayOfTransactionsUser << transaction
				end
			end
		end
		return @arrayOfTransactionsUser
	end

	#remove a question from the questions.txt file
	def removeTransaction(name, numString)
		numToRemove = numString.to_i - 1
		@arrayOfTransactions.delete(@arrayOfTransactionsUser[numToRemove])
		@arrayOfTransactionsUser.delete_at(numToRemove)
		self.updateCSVFile
	end

#add a row to the accounts.csv file
	def addRow(name,rowInfo)
		rowInfoArray = [name] + rowInfo.values
		csvrow = rowInfoArray.to_csv
		@arrayOfTransactionsUser.push(csvrow)
		@arrayOfTransactions.push(csvrow)
		self.updateCSVFile
	end

#update accounts.csv after adding/removing a row
	def updateCSVFile
		File.open('accounts.csv', 'w') do |file|
			file << "Account,Date,Payee,Category,Outflow,Inflow\n"
			@arrayOfTransactions.each do |line|
				file << line
			end
		end
	end



end

# def printCSV(params)
# 	newRow = EditRow.new
# 	newRow.test(params)
# 	newRow.loadArray
# 	return newRow.returnArray
# end

# def addRowFunction(params)
# 	newRow = EditRow.new
# 	newRow.test(params)
# 	newRow.loadArray
# 	newRow.addRow
# 	newRow.updateCSVFile
# end

# def removeRowFunction(params)
# 	newRow = EditRow.new
# 	newRow.test(params)
# 	newRow.loadArray
# 	newRow.removeRow
# 	newRow.updateCSVFile
# end

# def rowToArray(arrayOfRows,rowToGet)
# 	row_to_edit = arrayOfRows.values_at(rowToGet).shift
# 	newArray = row_to_edit.delete("\n").split(",")
# 	return newArray
# end

# def editRowFunction(params,rowToGet)
# 	columnToGet = params["x"].to_i
# 	newText = params["info_to_edit"]

# 	arrayOfRows = printCSV({})
# 	newArray = rowToArray(arrayOfRows,rowToGet)

# 	newArray[columnToGet] = newText
# 	newcsvrow = newArray.to_csv
# 	arrayOfRows[rowToGet] = newcsvrow
# 	updateCSVFile(arrayOfRows)
# end

# def updateCSVFile(arrayOfRows)
# 	File.open('accounts.csv', 'w') do |file|
# 		file << "Account,Date,Payee,Category,Outflow,Inflow\n"
# 		arrayOfRows.each do |line|
# 			file << line
# 		end
# 	end
# end