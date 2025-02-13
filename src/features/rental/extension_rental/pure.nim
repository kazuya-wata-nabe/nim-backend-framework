import std/sugar
import std/times


type
  RentalId = uint
  RentalModel = ref object
    id: RentalId
    deadline: DateTime

  RentalRepository = ref object
    items: seq[RentalModel]

  RentalUsecase* = ref object
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


proc invoke*(self: RentalUsecase, id: RentalId): void =
  let model = self.repository.find(id)
  let duration = initDuration(weeks = 2)
  let deadline = model.deadline + duration
  if model.deadline > deadline:
    discard
  else:
    discard




when isMainModule:
  let a = times.parse("2024-01-02", "yyyy-MM-dd")
  let b = initDuration(weeks = 2)
  
  doAssert a + b == times.parse("2024-01-16", "yyyy-MM-dd")