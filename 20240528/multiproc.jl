using Distributed

# Add worker processes
addprocs(24)  # Add 4 worker processes

@everywhere using Distributed

# Function to compute sum of array slice
@everywhere function partial_sum(arr, start, stop)
    return sum(arr[start:stop])
end

# Main function to divide work and collect results
function distributed_sum(arr)
    n = length(arr)
    chunk_size = n ÷ nworkers()
    futures = Vector{Future}(undef, nworkers())

    for i in 1:nworkers()
        start_idx = (i-1) * chunk_size + 1
        end_idx = i == nworkers() ? n : i * chunk_size
        futures[i] = @spawn partial_sum(arr, start_idx, end_idx)
    end

    return sum(fetch.(futures))
end

# Example usage
arr = rand(1_000_000)
result = distributed_sum(arr)
println("Sum of array elements: ", result)

# Remove worker processes
rmprocs(workers())
