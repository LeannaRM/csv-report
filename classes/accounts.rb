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