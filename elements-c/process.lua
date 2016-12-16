
local varcomps = {}
varcomps.type = U.dotype
varcomps[''] = U.content

local decl = {}
function decl.not_found() return ""  end
function decl.vardecl (ast)
	local B = buffer()
	local i
	for i=0,ast.last,1
	do
		B:add( P.select(varcomps,ast[i]) )
		B:add(" ")
	end
	B:add("\n")
	return B:str()
end
function decl.import (ast) return "#include <"..unquote(ast[0].content)..">\n" end
function decl.include (ast) return "#include "..ast[0].content.."\n" end
function decl.fundecl (ast)
	local i,a,b,vm,al
	local B = buffer()
	
	vm = {}
	al = alloc()
	
	B:add(U.dotype(ast[0]))
	B:add(" ")
	B:add(ast[1].content)
	B:add(" (")
	a = ast[2]
	for i=0,a.last,1 do
		b = a[i]
		if i>0 then B:add(",") end
		--print(b,b[0],b[1])
		B:add(U.dotype(b[0]))
		B:add(" ")
		B:add(U.allocvar(vm,al,b[1].content))
	end
	B:add(") {\n")
	a = ast[3]
	
	for i=0,a.last,1 do
		b = a[i]
		B:add( U.statement(b,vm,al) )
	end
	
	B:add("}\n")
	return B:str()
end


function main(ast)
	--call.source
	local B = buffer()
	local i
	for i=0,ast.last,1
	do B:add(P.select(decl,ast[i])) end
	call.result = B:str().."\n\n"
end


--P.select(decl,call.source)
main(call.source)

