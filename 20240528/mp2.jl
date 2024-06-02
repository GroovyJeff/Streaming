using Distributed

@everywhere function foo(i::Int)
 println(i)
 return(i)
end

arr = [i for i in 1:100]

print(arr)

pmap(foo, arr)






