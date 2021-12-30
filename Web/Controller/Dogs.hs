module Web.Controller.Dogs where

import Web.Controller.Prelude
import Web.View.Dogs.Index
import Web.View.Dogs.New
import Web.View.Dogs.Edit
import Web.View.Dogs.Show

instance Controller DogsController where
    action DogsAction = do
        dogs <- query @Dog |> fetch
        render IndexView { .. }

    action NewDogAction = do
        let dog = newRecord
        render NewView { .. }

    action ShowDogAction { dogId } = do
        dog <- fetch dogId
        render ShowView { .. }

    action EditDogAction { dogId } = do
        dog <- fetch dogId
        render EditView { .. }

    action UpdateDogAction { dogId } = do
        dog <- fetch dogId
        dog
            |> buildDog
            |> ifValid \case
                Left dog -> render EditView { .. }
                Right dog -> do
                    dog <- dog |> updateRecord
                    setSuccessMessage "Dog updated"
                    redirectTo EditDogAction { .. }

    action CreateDogAction = do
        let dog = newRecord @Dog
        dog
            |> buildDog
            |> ifValid \case
                Left dog -> render NewView { .. } 
                Right dog -> do
                    dog <- dog |> createRecord
                    setSuccessMessage "Dog created"
                    redirectTo DogsAction

    action DeleteDogAction { dogId } = do
        dog <- fetch dogId
        deleteRecord dog
        setSuccessMessage "Dog deleted"
        redirectTo DogsAction

buildDog dog = dog
    |> fill @'["name"]
