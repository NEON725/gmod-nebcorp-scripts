/* 


 _______ ___       _______   _______ .______      .___  ___.      ___      
|   ____|__ \     |       \ |   ____||   _  \     |   \/   |     /   \     
|  |__     ) |    |  .--.  ||  |__   |  |_)  |    |  \  /  |    /  ^  \    
|   __|   / /     |  |  |  ||   __|  |      /     |  |\/|  |   /  /_\  \   
|  |____ / /_     |  '--'  ||  |____ |  |\  \----.|  |  |  |  /  _____  \  
|_______|____|    |_______/ |_______|| _| `._____||__|  |__| /__/     \__\

                        __        __         
   ____ ___  ____ _____/ /__     / /_  __  __
  / __ `__ \/ __ `/ __  / _ \   / __ \/ / / /
 / / / / / / /_/ / /_/ /  __/  / /_/ / /_/ / 
/_/ /_/ /_/\__,_/\__,_/\___/  /_.___/\__, /  
                                    /____/ 
                                    
  _________              _____  _____       
 /   _____/ ____  __ ___/ ____\/ ____\__.__.
 \_____  \ /    \|  |  \   __\\   __<   |  |
 /        \   |  \  |  /|  |   |  |  \___  |
/_______  /___|  /____/ |__|   |__|  / ____|
        \/     \/                    \/  

yay, the client side shit, this is were all of the derma is done :D, yayyyyy!!

*/

local catch      = {}
local DERMA      = {}
local dontsend   = {}
local derma_bricks = {}
local derma_nails = {}

net.Receive("e2derma",function(len)
	local e2 = net.ReadUInt(16)
	local k = net.ReadString()
	local tbl = net.ReadTable()

    if !catch[e2] then catch[e2]       = {} end
    if !DERMA[e2] then DERMA[e2]       = {} end
    if !catch[e2].derma then catch[e2].derma = {} end
    if !catch[e2].old then catch[e2].old   = {} end
    
    catch[e2].old[k] = catch[e2].derma[k]
    catch[e2].derma[k] = tbl
    
    if DERMA[e2][k] == nil then 
        derma_bricks[catch[e2].derma[k].type](k,e2)
    else
        for a,b in pairs(catch[e2].derma[k]) do
            if istable(b) then 
                for x,y in pairs(b) do
                    if !istable(catch[e2].old[k][a]) then
                        if derma_nails[catch[e2].derma[k].type][a] == nil then 
                            derma_nails[a](k,e2)
                        else
                            derma_nails[catch[e2].derma[k].type][a](k,e2)
                        end
                    elseif y != catch[e2].old[k][a][x] then 
                        if derma_nails[catch[e2].derma[k].type][a] == nil then 
                            derma_nails[a](k,e2)
                        else
                            derma_nails[catch[e2].derma[k].type][a](k,e2)
                        end
                    end
                end
            elseif b != catch[e2].old[k][a] then
                if derma_nails[catch[e2].derma[k].type][a] == nil then 
                    derma_nails[a](k,e2)
                else
                    derma_nails[catch[e2].derma[k].type][a](k,e2)
                end
            end
        end
    end
end)





//**********************************parts*************************************\\

//*********bricks**********\\
derma_bricks.dPanel = function(k,e2)
    
    tbl = catch[e2].derma[k]
    
    
    DERMA[e2][k] = vgui.Create( "DFrame" )
    DERMA[e2][k]:SetPos( tbl.pos[1] , tbl.pos[2] ) 
    DERMA[e2][k]:SetSize( tbl.size[1] , tbl.size[2] ) 
    DERMA[e2][k]:SetTitle( tbl.text )
    local show = false
    if tbl.show != 0 then show = true end
    DERMA[e2][k]:SetVisible( show )
    DERMA[e2][k]:SetDraggable( true )
    DERMA[e2][k]:ShowCloseButton( true )
    DERMA[e2][k]:SetDeleteOnClose(false)

    if tbl.cCol != false then
        DERMA[e2][k].Paint = function()
            draw.RoundedBox( 4, 0, 0, DERMA[e2][k]:GetWide(),DERMA[e2][k]:GetTall(), catch[e2].derma[k].cCol )
            surface.SetDrawColor( 0, 0, 0, 150 )
            surface.DrawRect( 0, 22, DERMA[e2][k]:GetWide(), 1 )
        end
    end
    
end

derma_bricks.dButton = function(k,e2)
    
    tbl = catch[e2].derma[k]
    
    
    DERMA[e2][k] = vgui.Create( "DButton" )
    DERMA[e2][k]:SetParent( DERMA[e2][tbl.parent] )
    DERMA[e2][k]:SetText( tbl.text )
    DERMA[e2][k]:SetPos( tbl.pos[1] , tbl.pos[2] )
    DERMA[e2][k]:SetSize(tbl.size[1] , tbl.size[2] )
    DERMA[e2][k].DoClick = function ()
        RunConsoleCommand("_e2derma",e2,k )
    end
    
    if tbl.cCol != false then
        DERMA[e2][k].Paint = function()
            local w, h = DERMA[e2][k]:GetSize()

            if ( DERMA[e2][k].m_bBackground ) then
        		local col = catch[e2].derma[k].cCol
                surface.SetDrawColor( col )
                DERMA[e2][k]:DrawFilledRect()
            end
            derma.SkinHook( "PaintOver", "Button", DERMA[e2][k] )
        end
    end
    
end

derma_bricks.dCheckBox = function(k,e2)
    
    tbl = catch[e2].derma[k]
    
    DERMA[e2][k] = vgui.Create( "DCheckBoxLabel", DERMA[e2][tbl.parent] )
    DERMA[e2][k]:SetPos( tbl.pos[1] , tbl.pos[2] )
    DERMA[e2][k]:SetText( tbl.text )
    DERMA[e2][k]:SetValue( tbl.val )
    DERMA[e2][k]:SizeToContents()
    DERMA[e2][k]:SetTextColor(tbl.cCol)
    DERMA[e2][k].OnChange = function(bval)
        local val = 0
        if DERMA[e2][k].Button:GetChecked() then val = 1 end
        RunConsoleCommand("_e2derma",e2,k,val)
    end

end

derma_bricks.dSlider = function(k,e2)
    
    tbl = catch[e2].derma[k]
    
    DERMA[e2][k] = vgui.Create( "DNumSlider", DERMA[e2][tbl.parent] )
    DERMA[e2][k]:SetPos( tbl.pos[1] , tbl.pos[2] )
    DERMA[e2][k]:SetSize( tbl.length , 40 ) 
    DERMA[e2][k]:SetText( tbl.text )
    DERMA[e2][k]:SetMin( tbl.min ) 
    DERMA[e2][k]:SetMax( tbl.max ) 
    DERMA[e2][k]:SetDecimals( 0 ) 
    DERMA[e2][k]:SetValue( tbl.val )
    DERMA[e2][k].OnValueChanged = function()
        local val = DERMA[e2][k]:GetValue()
        RunConsoleCommand( "_e2derma" , e2 , k , val )
    end
	DERMA[e2][k]:GetTextArea():RequestFocus( )
end

derma_bricks.dTextBox = function(k,e2)
    
    tbl = catch[e2].derma[k]
    
    DERMA[e2][k] = vgui.Create( "DTextEntry" , DERMA[e2][tbl.parent] )
    DERMA[e2][k]:SetPos( tbl.pos[1] , tbl.pos[2] )
    DERMA[e2][k]:SetTall(  20 )
    DERMA[e2][k]:SetWide(  tbl.length )
    DERMA[e2][k]:SetValue( tbl.text )

    DERMA[e2][k].OnMousePressed  = function()

        
        local DermaText = vgui.Create( "DTextEntry" )
        DermaText:SetTall( 20 )
        DermaText:SetEnterAllowed( true )
        DermaText:SetValue(DERMA[e2][k]:GetValue())
        function DermaText:Think()
            local x ,y  = DERMA[e2][k]:GetPos();
            local x2,y2 = DERMA[e2][tbl.parent]:GetPos();
            DermaText:SetPos( x2+x,y2+y )
            DermaText:SetWide( DERMA[e2][k]:GetWide( ) )	
        end
        
        DermaText.OnLoseFocus = function()
            DERMA[e2][k]:UpdateConvarValue()
	        hook.Call( "OnTextEntryLoseFocus", nil, DERMA[e2][k] )
            DERMA[e2][k]:SetValue(DermaText:GetValue())
            RunConsoleCommand( "_e2derma" , e2 , k , DermaText:GetValue() )
            DermaText:Remove( ) 
        end
        DermaText:MakePopup()
        DermaText:RequestFocus( )

 
    end
    
    
end


derma_bricks.dImage = function(k,e2)
    
    tbl = catch[e2].derma[k]
    
    DERMA[e2][k] = vgui.Create( "DImage", DERMA[e2][tbl.parent] )
    DERMA[e2][k]:SetPos( tbl.pos[1] , tbl.pos[2] )
    DERMA[e2][k]:SetImage( tbl.image ) 
    DERMA[e2][k]:SetSize( tbl.size[1] , tbl.size[2] )
    DERMA[e2][k]:SetImageColor(  tbl.cCol)
end



derma_bricks.dDropBox = function(k,e2)
    
    tbl = catch[e2].derma[k]
    
    DERMA[e2][k] = vgui.Create( "DMultiChoice", DERMA[e2][tbl.parent] )
    DERMA[e2][k]:SetPos( tbl.pos[1] , tbl.pos[2] ) 
    DERMA[e2][k]:SetSize( tbl.length , 20 )
    DERMA[e2][k]:SetText( tbl.text )
    DERMA[e2][k].Choices = tbl.array
    DERMA[e2][k].OnSelect = function(index,value,data)
        RunConsoleCommand("_e2derma",e2 , k ,  DERMA[e2][k]:GetOptionText(value) )
    end
end

derma_bricks.dLabel = function(k,e2)
    
    tbl = catch[e2].derma[k]
    
    DERMA[e2][k] = vgui.Create( "DLabel", DERMA[e2][tbl.parent] )
    DERMA[e2][k]:SetPos(  tbl.pos[1] , tbl.pos[2])
    DERMA[e2][k]:SetText( tbl.text )
    DERMA[e2][k]:SetTextColor(tbl.cCol)
    DERMA[e2][k]:SizeToContents()
    
end

derma_bricks.dTabHolder = function(k,e2)
    
    tbl = catch[e2].derma[k]
    
    DERMA[e2][k] = vgui.Create( "DPropertySheet" , DERMA[e2][tbl.parent] )
    DERMA[e2][k]:SetPos( tbl.pos[1] , tbl.pos[2] )
    DERMA[e2][k]:SetSize( tbl.size[1] , tbl.size[2] )
    
end


derma_bricks.dTab = function(k,e2)
    
    tbl = catch[e2].derma[k]
    
    if catch[e2].derma[tbl.parent] == nil then return end
    if catch[e2].derma[tbl.parent].type != "dTabHolder" then return end
    
    DERMA[e2][k] = vgui.Create( "DFrame" )
    DERMA[e2][k]:SetTitle( "" )
    DERMA[e2][k]:SetVisible( true )
    DERMA[e2][k]:SetDraggable( false)
    DERMA[e2][k]:ShowCloseButton( false )
    DERMA[e2][k]:SetDeleteOnClose(false)
    
    DERMA[e2][tbl.parent]:AddSheet(k, DERMA[e2][k] , "icon16/user.png", false, false, k)
    
    
end


derma_bricks.dListBox = function(k,e2)
    
    tbl = catch[e2].derma[k]
	if catch[e2].derma[tbl.parent] == nil then return end

    DERMA[e2][k] = vgui.Create("DListView")
    DERMA[e2][k]:SetParent(DERMA[e2][tbl.parent])
    DERMA[e2][k]:SetPos(tbl.pos[1] , tbl.pos[2])
    DERMA[e2][k]:SetSize(tbl.size[1] , tbl.size[2])
    DERMA[e2][k]:SetMultiSelect(false)
    DERMA[e2][k]:AddColumn(k)
    
    
    for n,v in pairs(tbl.array) do
        local line = DERMA[e2][k]:AddLine(v)
        line.OnSelect = function()
        RunConsoleCommand( "_e2derma", e2 , k,  v )
        end
    end
end







//********nails*********\\

// the nails are for if something get changed after they are created

derma_nails.pos = function(k,e2)
    DERMA[e2][k]:SetPos( catch[e2].derma[k].pos[1] , catch[e2].derma[k].pos[2] )
end

derma_nails.size = function(k,e2)
    DERMA[e2][k]:SetSize( catch[e2].derma[k].size[1] , catch[e2].derma[k].size[2] )
end

derma_nails.text = function(k,e2) 
    DERMA[e2][k]:SetText( catch[e2].derma[k].text )
end

derma_nails.show   = function(k,e2) end
derma_nails.cCol   = function(k,e2) end
derma_nails.val    = function(k,e2) end
derma_nails.min    = function(k,e2) end
derma_nails.max    = function(k,e2) end
derma_nails.length = function(k,e2) end
derma_nails.image  = function(k,e2) end
derma_nails.array  = function(k,e2) end


//here are the specific, if a function cant be found here then it will default to the nails above
derma_nails.dPanel = {}

derma_nails.dPanel.cCol = function(k,e2)
    DERMA[e2][k].Paint = function()
        draw.RoundedBox( 4, 0, 0, DERMA[e2][k]:GetWide(),DERMA[e2][k]:GetTall(), catch[e2].derma[k].cCol )
        surface.SetDrawColor( 0, 0, 0, 150 )
        surface.DrawRect( 0, 22, DERMA[e2][k]:GetWide(), 1 )
    end
end

derma_nails.dPanel.text = function(k,e2)
    DERMA[e2][k]:SetTitle( catch[e2].derma[k].text )
end

derma_nails.dPanel.show = function(k,e2)    
    local show = false
    if catch[e2].derma[k].show != 0 then show = true end
    DERMA[e2][k]:SetVisible( show )
end


derma_nails.dButton = {}

derma_nails.dButton.cCol = function(k,e2)
    DERMA[e2][k].Paint = function()
        local w, h = DERMA[e2][k]:GetSize()

        if ( DERMA[e2][k].m_bBackground ) then
        	local col = catch[e2].derma[k].cCol
            surface.SetDrawColor( col.r, col.g, col.b, col.a )
            DERMA[e2][k]:DrawFilledRect()
        end
        derma.SkinHook( "PaintOver", "Button", DERMA[e2][k] )
    end
end


derma_nails.dCheckBox = {}
derma_nails.dCheckBox.cCol = function(k,e2)
    DERMA[e2][k]:SetTextColor(catch[e2].derma[k].cCol)
end
derma_nails.dCheckBox.size = function(k,e2) end
derma_nails.dCheckBox.val  = function(k,e2) 
    DERMA[e2][k]:SetValue( catch[e2].derma[k].val )
end


derma_nails.dSlider = {}
derma_nails.dSlider.cCol = function(k,e2)
    DERMA[e2][k].Label:SetTextColor(catch[e2].derma[k].cCol)
end
derma_nails.dSlider.size = function(k,e2) end
derma_nails.dSlider.length = function(k,e2) 
    DERMA[e2][k]:SetSize( catch[e2].derma[k].length , 40 )
end
derma_nails.dSlider.val  = function(k,e2) 
    DERMA[e2][k]:SetValue( catch[e2].derma[k].val )
end


derma_nails.dTextBox = {}
derma_nails.dTextBox.size = function(k,e2) end
derma_nails.dTextBox.length = function(k,e2) 
    DERMA[e2][k]:SetSize( catch[e2].derma[k].length , 20 )
end
derma_nails.dTextBox.text = function(k,e2)
    DERMA[e2][k]:SetValue( catch[e2].derma[k].text )
end

derma_nails.dImage = {}
derma_nails.dImage.text = function(k,e2) end
derma_nails.dImage.cCol = function(k,e2) 
    DERMA[e2][k]:SetImageColor(  catch[e2].derma[k].cCol )
end
derma_nails.dImage.image = function(k,e2) 
    DERMA[e2][k]:SetImage( catch[e2].derma[k].image ) 
end


derma_nails.dDropBox = {}
derma_nails.dDropBox.array = function(k,e2)
    DERMA[e2][k].Choices = catch[e2].derma[k].array
end
derma_nails.dDropBox.size = function(k,e2) end
derma_nails.dDropBox.lenght = function(k,e2) 
    DERMA[e2][k]:SetSize( catch[e2].derma[k].length , 20 )
end


derma_nails.dLabel = {}
derma_nails.dLabel.size = function(k,e2) end
derma_nails.dLabel.cCol = function(k,e2) 
    DERMA[e2][k]:SetTextColor(catch[e2].derma[k].cCol) 
end


derma_nails.dTabHolder = {}
derma_nails.dTabHolder.text = function(k,e2) end


derma_nails.dTab = {}
derma_nails.dTab.text = function(k,e2) end


derma_nails.dListBox = {}
derma_nails.dListBox.array = function(k,e2) 
    DERMA[e2][k]:Clear()
    for n,v in ipairs(catch[e2].derma[k].array) do
        local line = DERMA[e2][k]:AddLine(v)
        line.OnSelect = function()
        RunConsoleCommand("_e2derma" , e2, k ,  v )
        end
    end
end
derma_nails.dListBox.text = function(k,e2) end


//****************************************************************************\\

	
net.Receive("e2derma_remove",function(len)
    local e2 = net.ReadUInt(16)
    if catch[e2] && catch[e2].derma then 
        for k,v in pairs(catch[e2].derma) do
            if DERMA[e2][k] then 
                if DERMA[e2][k].Remove then 
                    DERMA[e2][k]:Remove( )
                end
            end
            catch[e2].derma[k]=nil
        end
    end 
    
    DERMA[e2] = nil
    catch[e2] = {}
    dontsend[e2] = CurTime()
    gui.EnableScreenClicker(false)
end)


CreateClientConVar("e2_dHW_", "0", false, true )
RunConsoleCommand( "e2_dHW_", surface.ScreenHeight( ) .. "," .. surface.ScreenWidth( ) )
