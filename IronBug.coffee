RandomString = -> Math.random().toString(36).substring(7)
SetParameter = (parameterName, parameterValue) ->
	Router.QueryBuilder.setParameter parameterName, parameterValue
	changes = Session.get "changes"
	changes.push(
		ParameterName: parameterName
		ParameterValue: parameterValue
		Time: Date.now()
	)
	Session.set "changes", changes

Router.QueryBuilder =
  setParameter: (parameter, value) ->
    queryObject = Iron.Location.get().queryObject
    if value?
      queryObject[parameter] = value
    else
      delete queryObject[parameter]

    valuePairs = []
    for queryParameter, queryValue of queryObject
      valuePairs.push("#{ queryParameter }=#{ queryValue }")

    newUrl = Router.current().route.path {}, { query: valuePairs.join('&') }

    Router.go newUrl
    return

if (Meteor.isClient) 
	Session.setDefault "changes", []

	Template.template.events(
		'click button#add': ->
			SetParameter RandomString(), RandomString()
		'click button.change': (event) ->
			SetParameter event.target.id, RandomString()
		'click a[role="menuitem"]': (event) ->
			console.log "setting BOOTSTRAP PARAMETER to " + event.target.innerHTML
			SetParameter "bootstrap", event.target.innerHTML
	)
	
	Template.template.helpers(
		Changes: -> Session.get "changes"
	)
	
Router.route('/', ->
	@render('template', {
		data: -> 
			queries = ((
					ParameterName: parameterName 
					ParameterValue: parameterValue
				) for parameterName, parameterValue of @params.query)
			return {
				Queries: queries
				BootstrapQuery: queries.filter((query) -> query.ParameterName is "bootstrap")[0] ? (
					ParameterValue: "parameter not set"
				)
				BootstrapQueryOptions: [
					Name: "Foo"
				,
					Name: "Bar"
				,
					Name: "Foobar"
				]
			}
	})
)
