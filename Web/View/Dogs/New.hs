module Web.View.Dogs.New where
import Web.View.Prelude

data NewView = NewView { dog :: Dog }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Dog</h1>
        {renderForm dog}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Dogs" DogsAction
                , breadcrumbText "New Dog"
                ]

renderForm :: Dog -> Html
renderForm dog = formFor dog [hsx|
    {(textField #name)}
    {submitButton}

|]