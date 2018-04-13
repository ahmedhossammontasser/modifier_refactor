class String
	def from_german_to_f
		if self.count(",") > 1 ||  self[/[,0-9]+/]  != self
			raise "Invalid input"
		end
		self.gsub(',', '.').to_f

	end
end
