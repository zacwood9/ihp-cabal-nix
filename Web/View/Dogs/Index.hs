module Web.View.Dogs.Index where
import Web.View.Prelude

data IndexView = IndexView { dogs :: [ Dog ]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewDogAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Dog</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach dogs renderDog}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Dogs" DogsAction
                ]

renderDog :: Dog -> Html
renderDog dog = [hsx|
    <tr>
        <td>{dog}</td>
        <td><a href={ShowDogAction (get #id dog)}>Show</a></td>
        <td><a href={EditDogAction (get #id dog)} class="text-muted">Edit</a></td>
        <td><a href={DeleteDogAction (get #id dog)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]