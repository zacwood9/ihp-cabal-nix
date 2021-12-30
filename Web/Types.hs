module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

data DogsController
    = DogsAction
    | NewDogAction
    | ShowDogAction { dogId :: !(Id Dog) }
    | CreateDogAction
    | EditDogAction { dogId :: !(Id Dog) }
    | UpdateDogAction { dogId :: !(Id Dog) }
    | DeleteDogAction { dogId :: !(Id Dog) }
    deriving (Eq, Show, Data)
