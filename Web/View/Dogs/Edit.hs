module Web.View.Dogs.Edit where
import Web.View.Prelude

data EditView = EditView { dog :: Dog }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Dog</h1>
        {renderForm dog}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Dogs" DogsAction
                , breadcrumbText "Edit Dog"
                ]

renderForm :: Dog -> Html
renderForm dog = formFor dog [hsx|
    {(textField #name)}
    {submitButton}

|]