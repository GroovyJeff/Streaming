using Symbolics

include("electoral-votes.jl")

# There are 56 electoral "regions" in the United States: 48 states and the District of Columbia that give all of their electoral votes to one candidate, Maine, which splits its votes 2-1-1 (for 3 regions), and Nebraska, which splits its votes 2-1-1-1

# we actually only need the numbers of votes not the state names

numVotes = [i[2] for i in votes]

# The following optional commands will confirm we have 568 votes total split across 56 "regions":

# @assert sum(numVotes) == 538 "total must be 538"

# @assert length(numVotes) == 56 "total must be 56"

# the technique we're using here is to multiply polynomials of the form (1+x^i), so that the coefficient after expansion is the total number of ways to reach that coefficient through summing

@variables x

polys = [1 + x^i for i in numVotes]

# we need the expanded form to see the coefficients

poly = expand(prod(polys))

# get the coefficient for 269

tie = Symbolics.coeff(poly, x^269)

# the answer is 543865928987312

# we know the total number of vote distributions for two candidates is 2^56 because that's how many subsets of 56 regions we have; however, we can also confirm this using Julia

allCoeffs = [Symbolics.coeff(poly, x^i) for i in range(0,538)]

grandTotal = sum(allCoeffs)

# the answer above is 72057594037927936

@assert grandTotal == 2^56 "power set equivalence"

# to get the final answer we divide

result = tie/grandTotal

# the answer is 0.007547655958385802 or about 0.755%
