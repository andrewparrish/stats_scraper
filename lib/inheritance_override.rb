class Class
	def descendants
		ObjectSpace.each_object(::Class) { |klass| klass < self }
	end
end
