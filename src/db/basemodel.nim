type WriteModel* = concept x
  x.tableName() is string

type ReadModel* = concept x
  x.id is int64
  x.tableName() is string
