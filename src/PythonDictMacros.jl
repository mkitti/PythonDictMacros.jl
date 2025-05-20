module PythonDictMacros

using PythonCall

export @pythondict

macro pythondict(e)
    return process_rhs(e)
end

function process_rhs(e::Expr)
    if e.head == :braces
        return Expr(:call, :pydict, Expr(:vect, process_lhs.(e.args)...))
    end
    if e.head == :vect
        return Expr(:call, :pylist, e.args)
    end
    return e
end
function process_rhs(s::Symbol) 
    return s == :True ? true :
           s == :False ? false :
           s
end
process_rhs(e) = e

function process_lhs(e::Expr)
    if e.head == :call && e.args[1] == :(:)
        return Expr(:call, :Pair, e.args[2], process_rhs(e.args[3]))
    end
    return e
end
process_lhs(e) = e

function single_to_double_quotes(s::AbstractString)
    return replace(s, '\'' => '"')
end

end
