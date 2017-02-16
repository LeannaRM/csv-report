require 'csv'
require 'pry'

#load accounts.csv file into program
class AccountByTransaction
	def setup(name)
		@accountname = name
		@arrayOfTransactions = []
		@arrayOfOtherUsers = []
		self.loadArray()
	end

	def loadArray()
		CSV.foreach('accounts.csv', {headers:true}) do |row|
			row["Account"] = row["Account"].chomp
			row["Category"] = row["Category"].chomp
			row["Payee"] = row["Payee"].chomp
			row["Inflow"] = row["Inflow"].delete(",")
			row["Outflow"] = row["Outflow"].delete(",")

			if row["Account"] != @accountname.capitalize
				@arrayOfOtherUsers.push(row.to_s)
			end
			if row["Account"] == @accountname.capitalize
				# tempvar = row["Account"]+","+row["Date"]+","+row["Payee"]+","+row["Category"]+","+row["Outflow"]+","+row["Inflow"]+"\n"
				@arrayOfTransactions.push(row["Account"]+","+row["Date"]+","+row["Payee"]+","+row["Category"])
			end
			# binding.pry
		end
	end
end