using NearestNeighbors

mat = rand(3, 10000)

tree = KDTree(mat)

# tree = KDTree(mat)

# poitn closest to origin
nn(tree, [0,0,0])

# (6922, 0.05879645152596118)

# the 6922nd elt

mat[:, 6922]

# 10 closest to 0,0,0

knn(tree, [0,0,0], 10)

# above first element is FURTHEST

knn(tree, [0,0,0], 5, true)

# the furthest

knn(tree, [0,0,0], 10000, true)

# furthest from 0,0,0

mat[:, 1647]

# knn(tree, [0,0,0], 10000, true)[1][:-1]

# knn(tree, mat[:, 1], 10000, true)[1][10000]
# knn(tree, mat[:, 1], 10000, true)[2][10000]

