# <link rel="stylesheet" href="../css/styles.css" media="screen">
class DropDownList extends Widget
    constructor:( target )->
        super target

        @buildOptions()
        @hideOptions()
        @updateDummy()
    
    checkTarget:( target )->
        unless @isTag target, "select"
            throw "A DropDownList only allow select nodes as target" 
    
    createDummy:->
        dummy = $ "<span class='dropdownlist'>
                       <span class='value'></span>
                       <span class='list'></span>
                   </span>"
        @optionsList = dummy.children ".list"
        dummy
    
    updateDummy:->
        @dummy.find(".value").text @getOptionLabel @jTarget.children("option[selected]")
    
    buildOptions:->
        options = @jTarget.children "option"
        options.each (i,o)=>
            option = $ o
            label = @getOptionLabel option
            @optionsList.append $ "<span class='option'>#{label}</span>"
    
    hideOptions:->
        @optionsList.hide()
    
    showOptions:->
        @optionsList.show()
    
    getOptionLabel:( option )->
        if option.attr "label" then option.attr "label" else option.text()  

    click:(e)->
        if @optionsList.attr("style").indexOf("display: none;") is -1
            @hideOptions()
        else
            @showOptions()

# Address the access restriction due to the sandboxing when used
# directly in a browser with the `text/coffeescript` mode. 
if window? 
    window.DropDownList = DropDownList