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