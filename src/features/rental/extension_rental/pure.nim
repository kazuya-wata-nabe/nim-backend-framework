import std/options
import std/times

type
  RentalId = uint

  ResultState = enum 
    rOk
    rNg

  RentalModel = ref object
    id: RentalId
    begin: DateTime

  ExecResult = ref object
    id: RentalId
    begin: DateTime

  RentalRepository = ref object
    items: seq[RentalModel]

  RentalUsecase* = ref object
    repository*: RentalRepository


proc extend(model: RentalModel, date: DateTime): RentalModel =
  RentalModel(
    id: model.id,
    begin: model.begin + initDuration(weeks = 2)
  )

proc newRentalRepository*(): RentalRepository = 
  RentalRepository(
    items: @[
      RentalModel(
        id: 1,
        begin: times.parse("2024-02-02", "yyyy-MM-dd")
      ),
      RentalModel(
        id: 2,
        begin: times.parse("2024-02-03", "yyyy-MM-dd")
      )
    ]
  )

proc newRentalRepository*(items: seq[RentalModel]): RentalRepository = 
  RentalRepository(
    items: items
  )

func newRentalUsecase*(repository: RentalRepository): RentalUsecase =
  RentalUsecase(repository: repository)


proc find(self: RentalRepository, id: RentalId): Option[RentalModel] =
  result = none(RentalModel)
  for item in self.items:
    if item.id == id:
      result = some(item)
      break



proc invoke*(self: RentalUsecase, id: RentalId): Option[RentalModel] =
  let model = self.repository.find(id)
  if model.isNone():
    return none(RentalModel)

  let it = model.get()
  let duration = initDuration(weeks = 2)
  let deadline = it.begin + duration
  if it.begin > deadline:
    some(RentalModel(id: it.id, begin: deadline))
  else:
    none(RentalModel)


when isMainModule:
  let items = @[
    RentalModel(
      id: RentalId 1,
      begin: times.parse("2024-02-22", "yyyy-MM-dd")
    ),
    RentalModel(
      id: RentalId 2,
      begin: times.parse("2024-02-23", "yyyy-MM-dd")
    )
  ]
  let usecase = newRentalRepository(items).newRentalUsecase()
  
  block:
    let id = RentalId 1
    let newModel = usecase.invoke(id)
    doAssert newModel.isSome() == true