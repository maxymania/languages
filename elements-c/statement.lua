local statement = {}
--local json = require'json'
function statement.vardecl (ast,vm,al)
	local str = U.dotype(ast[0]).." ".. U.allocvar(vm,al,ast[1].content)
	if ast.len==3 then
		str = str .. " = " .. U.expr(ast[2],vm,al)
	end
	return str..";\n"
end
function statement.expr (ast,vm,al)
	local e = U.expr(ast[0],vm,al)
	return e..";\n"
end

local function mayexpr (ast,vm,al)
	if ast.len==0 then return "" end
	return U.expr(ast[0],vm,al)
end

function statement.forlp (ast,vm,al)
	local B = buffer()
	B:add("for(")
	B:add(mayexpr(ast[0],vm,al))
	B:add(";")
	B:add(mayexpr(ast[1],vm,al))
	B:add(";")
	B:add(mayexpr(ast[2],vm,al))
	B:add(")\n")
	B:add(U.statement(ast[3],vm,al))
	return B:str()
end
function statement.ifs (ast,vm,al)
	local B = buffer()
	B:add("if(")
	B:add(U.expr(ast[0],vm,al))
	B:add(")\n")
	B:add(U.statement(ast[1],vm,al))
	return B:str()
end

function statement.whlp (ast,vm,al)
	local B = buffer()
	B:add("while(")
	B:add(U.expr(ast[0],vm,al))
	B:add(")\n")
	B:add(U.statement(ast[1],vm,al))
	return B:str()
end
function statement.dowh (ast,vm,al)
	local B = buffer()
	B:add("do\n")
	B:add(U.statement(ast[0],vm,al))
	B:add("while(")
	B:add(U.expr(ast[1],vm,al))
	B:add(");\n")
	return B:str()
end
function statement.block (ast,vm,al)
	local B = buffer()
	B:add("{\n")
	vm = clone(vm)
	for i=0,ast.last,1 do
		b = ast[i]
		B:add( U.statement(b,vm,al) )
	end
	B:add("}\n")
	return B:str()
end

function U.statement(ast,vm,al)
	return P.select(statement,ast,vm,al)
end

