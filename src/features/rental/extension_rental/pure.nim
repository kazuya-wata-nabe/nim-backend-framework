import std/sugar
import std/times
# workflow
#   data:
#     - rentalId: uint 
#     - rental_model
#         id: rentalId
#         name: string
#   input:
#     - rentalId
#   output:
#     - rental_model
#   dependency:
#     - rental_repository




type
  RentalId = uint
  RentalModel = ref object
    id: RentalId
    deadline: DateTime

  RentalRepository = ref object
    items: seq[RentalModel]

  RentalUsecase = ref object
    repository: RentalRepository


proc extend(model: RentalModel, date: DateTime): RentalModel =
  if model.deadline > date:
    RentalModel(
      id: model.id,
      deadline: model.deadline + initDuration(weeks = 2)
    )
  else:
    model



func newRentalUsecase*(repository: RentalRepository): RentalUsecase =
  RentalUsecase()


proc find(self: RentalRepository, id: RentalId): RentalModel =
  for item in self.items:
    if item.id == id:
      result = item
      break



when isMainModule:
  let a = times.parse("2024-01-02", "yyyy-MM-dd")
  let b = initDuration(weeks = 2)
  
  doAssert a + b == times.parse("2024-01-16", "yyyy-MM-dd")