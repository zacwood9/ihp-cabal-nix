module Web.View.Dogs.Show where
import Web.View.Prelude

data ShowView = ShowView { dog :: Dog }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Dog</h1>
        <p>{dog}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Dogs" DogsAction
                            , breadcrumbText "Show Dog"
                            ]