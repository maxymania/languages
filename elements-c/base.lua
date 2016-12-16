U.content = function (ast) return ast.content end

function U.dotype(ast)
	local str = nil
	local cur,i,isPtr
	for i=0,ast.last,1
	do
		cur = ast[i]
		if cur.head == '' then
			if str then
				str = str .. " " .. cur.content
			else
				str = cur.content
			end
		elseif cur.head == 'ptr' then
			isPtr = true
			str = str .. "*"
		elseif cur.head == 'const_ptr' then
			if isPtr then
				str = str .. " const *"
			else
				str = "const " .. str .. "*"
			end
			isPtr = true
		end
	end
	return str
end

function U.allocvar(vm,al,name)
	local nn = al:alloc(name)
	vm[name] = nn
	return nn
end