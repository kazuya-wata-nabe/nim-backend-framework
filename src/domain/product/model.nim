
type PersistInterface = tuple
  tableName: proc(): string

type Product = ref object of RootObj
  name: string
  description: string
  price: uint8
  stock: uint8

type ProductPersistModel = ref object of Product
  id: uint64


func t[T: PersistInterface](self: T): string = t.tableName
