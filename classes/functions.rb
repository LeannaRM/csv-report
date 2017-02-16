require 'csv'
require 'pry'

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

# def checkUsername(user)
# 	unless user
# 		redirect('/loginerror')
# 	end
# end