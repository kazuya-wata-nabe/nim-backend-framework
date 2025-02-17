import std/sugar
import std/options
import std/times


type
  RentalId = uint

  RentalState = enum 
    rOk, rNg

  RentalModel = ref object
    id: RentalId
    begin: DateTime

  RentalRepository = ref object
    items: seq[RentalModel]

  RentalUsecase* = ref object
    repository: RentalRepository


proc extend(model: RentalModel, date: DateTime): RentalModel =
  RentalModel(
    id: model.id,
    begin: model.begin + initDuration(weeks = 2)
  )



func newRentalUsecase*(repository: RentalRepository): RentalUsecase =
  RentalUsecase()



proc find(self: RentalRepository, id: RentalId): RentalModel =
  for item in self.items:
    if item.id == id:
      result = item
      break


proc invoke*(self: RentalUsecase, id: RentalId): Option[RentalModel] =
  let model = self.repository.find(id)
  let duration = initDuration(weeks = 2)
  let deadline = model.begin + duration
  if model.begin > deadline:
    some(RentalModel(id: model.id, begin: deadline))
  else:
    none(RentalModel)




when isMainModule:
  let a = times.parse("2024-01-02", "yyyy-MM-dd")
  let b = initDuration(weeks = 2)
  
  doAssert a + b == times.parse("2024-01-16", "yyyy-MM-dd")