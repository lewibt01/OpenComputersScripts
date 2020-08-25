local component = require("component")
local event = require("event")
local term = require("term")
local gpu = component.gpu

 -- Safety Checks

if not component.isAvailable("draconic_reactor") then
  print("Reactor not connected. Please connect computer to reactor with an Adapter block.")
  os.exit()
end
reactor = component.draconic_reactor
local flux_gates = {}
for x,y in pairs(component.list("flux_gate")) do
  flux_gates[#flux_gates+1] = x
end
if #flux_gates < 2 then
  print("Not enough flux gates connected; please connect inflow and outflow flux gates with Adapter blocks.")
  os.exit()
end
flux_in = component.proxy(flux_gates[1])
flux_out = component.proxy(flux_gates[2])
if not flux_in or not flux_out then
  print("Not enough flux gates connected; please connect inflow and outflow flux gates with Adapter blocks.")
  os.exit()
end

 -- Functions

function exit_msg(msg)
  term.clear()
  print(msg)
  os.exit()
end

function modify_temp(offset)
  local new_temp = ideal_temp + offset
  if new_temp > 8000 then
    new_temp = 8000
  elseif new_temp < 2500 then
    new_temp = 2500
  end
  ideal_temp = new_temp
end

function modify_field(offset)
  local new_strength = ideal_strength + offset
  if new_strength > 90 then
    new_strength = 90
  elseif new_strength < 1 then
    new_strength = 1
  end
  ideal_strength = new_strength
end

 -- Buttons

local adj_button_width = 19
local temp_adjust_x_offset = 68
local temp_adjust_y_offset = 2
local field_adjust_x_offset = temp_adjust_x_offset + adj_button_width + 2
local field_adjust_y_offset = 2

local buttons = {
  start={
    x=42,
    y=2,
    width=24,
    height=7,
    text="Start",
    action=function() 
      if safe then
        state = "Charging"
        reactor.chargeReactor()
      elseif shutting_down then
        state = "Active"
        reactor.activateReactor()
      end
    end,
    condition=function() return safe or shutting_down end
  },
  shutdown={
    x=42,
    y=12,
    width=24,
    height=7,
    text="Shutdown",
    action=function()
      state = "Manual Shutdown"
      reactor.stopReactor()
    end,
    condition=function() return running end
  },
  switch_gates={
    x=2,
    y=20,
    width=24,
    height=3,
    text="Swap flux gates",
    action=function()
      local old_addr = flux_in.address
      flux_in = component.proxy(flux_out.address)
      flux_out = component.proxy(old_addr)
    end,
    condition=function() return safe end
  },
  exit={
    x=42,
    y=12,
    width=24,
    height=7,
    text="Exit",
    action=function()
      event_loop = false
    end,
    condition=function() return safe end
  },
  temp_up_thousand={
    x=temp_adjust_x_offset,
    y=temp_adjust_y_offset,
    width=adj_button_width,
    height=1,
    text="+ 1000",
    action=function() modify_temp(1000) end
  },
  temp_up_hundred={
    x=temp_adjust_x_offset,
    y=temp_adjust_y_offset+2,
    width=adj_button_width,
    height=1,
    text="+ 100",
    action=function() modify_temp(100) end
  },
  temp_up_ten={
    x=temp_adjust_x_offset,
    y=temp_adjust_y_offset+4,
    width=adj_button_width,
    height=1,
    text="+ 10",
    action=function() modify_temp(10) end
  },
  temp_up_one={
    x=temp_adjust_x_offset,
    y=temp_adjust_y_offset+6,
    width=adj_button_width,
    height=1,
    text="+ 1",
    action=function() modify_temp(1) end
  },
  temp_down_thousand={
    x=temp_adjust_x_offset,
    y=temp_adjust_y_offset+16,
    width=adj_button_width,
    height=1,
    text="- 1000",
    action=function() modify_temp(-1000) end
  },
  temp_down_hundred={
    x=temp_adjust_x_offset,
    y=temp_adjust_y_offset+14,
    width=adj_button_width,
    height=1,
    text=" - 100",
    action=function() modify_temp(-100) end
  },
  temp_down_ten={
    x=temp_adjust_x_offset,
    y=temp_adjust_y_offset+12,
    width=adj_button_width,
    height=1,
    text="- 10",
    action=function() modify_temp(-10) end
  },
  temp_down_one={
    x=temp_adjust_x_offset,
    y=temp_adjust_y_offset+10,
    width=adj_button_width,
    height=1,
    text="- 1",
    action=function() modify_temp(-1) end
  },
  field_up_ten={
    x=field_adjust_x_offset,
    y=field_adjust_y_offset+4,
    width=adj_button_width,
    height=1,
    text="+ 10",
    action=function() modify_field(10) end
  },
  field_up_one={
    x=field_adjust_x_offset,
    y=field_adjust_y_offset+6,
    width=adj_button_width,
    height=1,
    text="+ 1",
    action=function() modify_field(1) end
  },
  field_down_ten={
    x=field_adjust_x_offset,
    y=field_adjust_y_offset+12,
    width=adj_button_width,
    height=1,
    text="- 10",
    action=function() modify_field(-10) end
  },
  field_down_one={
    x=field_adjust_x_offset,
    y=field_adjust_y_offset+10,
    width=adj_button_width,
    height=1,
    text="- 1",
    action=function() modify_field(-1) end
  }
}

 -- main code

flux_in.setFlowOverride(0)
flux_out.setFlowOverride(0)
flux_in.setOverrideEnabled(true)
flux_out.setOverrideEnabled(true)

local condition = reactor.getReactorInfo()
if not condition then
  print("Reactor not initialized, please ensure the stabilizers are properly laid out.")
  os.exit()
end

ideal_strength = 50

ideal_temp = 8000
cutoff_temp = 8100

 -- tweakable pid gains

inflow_P_gain = 1
inflow_I_gain = 0.04
inflow_D_gain = 0.1

outflow_P_gain = 500
outflow_I_gain = 0.5
outflow_II_gain = 0.0000003
outflow_D_gain = 60000

 -- initialize main loop

inflow_I_sum = 0
inflow_D_last = 0

outflow_I_sum = 0
outflow_II_sum = 0
outflow_D_last = 0

state = "Standby"
shutting_down = false

if condition.temperature > 25 then
  state = "Cooling"
end
if condition.temperature > 2000 then
  state = "Active"
end

 -- Possible states:
  --Standby
  --Charging
  --Active
  --Manual Shutdown
  --Emergency Shutdown
  --Cooling

event_loop = true
while event_loop do

  if not component.isAvailable("draconic_reactor") then
    exit_msg("Reactor disconnected, exiting")
  end

  if not component.isAvailable("flux_gate") then
    exit_msg("Flux gates disconnected, exiting")
  end

  local info = reactor.getReactorInfo()

  local inflow = 0
  local outflow = 0

  shutting_down = state == "Manual Shutdown" or state == "Emergency Shutdown"
  running = state == "Charging" or state == "Active"
  safe = state == "Standby" or state == "Cooling"

  if state == "Charging" then
    inflow = 200000

    if info.temperature > 2000 then
      reactor.activateReactor()
      state = "Active"
    end
  elseif state == "Cooling" then
    if info.temperature < 25 then
      state = "Standby"
    end
    inflow = 10
    outflow = 20
  elseif state == "Standby" then
    inflow = 10
    outflow = 20
  else
    -- adjust inflow rate based on field strength
   
    local field_error = (info.maxFieldStrength * (ideal_strength / 100)) - info.fieldStrength
    local proportional_field_error = field_error * inflow_P_gain
    inflow_I_sum = inflow_I_sum + field_error
    local integral_field_error = inflow_I_sum * inflow_I_gain
    local derivative_field_error = (field_error - inflow_D_last) * inflow_D_gain
    inflow_D_last = field_error
    local inflow_correction = proportional_field_error + integral_field_error + derivative_field_error
    if inflow_correction < 0 then
      inflow_I_sum = inflow_I_sum - field_error
    end
    inflow = inflow_correction

    if not shutting_down then

      -- adjust outflow rate based on core temperature

      local temp_error = ideal_temp - info.temperature
      local proportional_temp_error = temp_error * outflow_P_gain
      outflow_I_sum = outflow_I_sum + temp_error
      local integral_temp_error = outflow_I_sum * outflow_I_gain
      if math.abs(temp_error) < 100 then
        outflow_II_sum = outflow_II_sum + integral_temp_error
      else
        outflow_II_sum = 0
      end
      local second_integral_temp_error = outflow_II_sum * outflow_II_gain
      local derivative_temp_error = (temp_error - outflow_D_last) * outflow_D_gain
      outflow_D_last = temp_error
      local outflow_correction = proportional_temp_error + integral_temp_error + second_integral_temp_error + derivative_temp_error
      if outflow_correction < 0 then
        outflow_I_sum = outflow_I_sum - temp_error
      end
      outflow = outflow_correction

      -- cut off reactor in case of emergency

      if info.temperature > cutoff_temp then
        print("Reactor temperature greater than", cutoff_temp, ", failsafe activated, shutting down")
        outflow = 0
        state = "Emergency Shutdown"
        reactor.stopReactor()
      end
    else
      if info.temperature < 2000 then
        state = "Cooling"
      end
    end
  end

  if state ~= "Active" and not shutting_down then
    inflow_I_sum = 0
    inflow_D_last = 0
    outflow_I_sum = 0
    outflow_II_sum = 0
    outflow_D_last = 0
  end

  if inflow < 0 then
    inflow = 0
  end
  if outflow < 0 then
    outflow = 0
  end

  inflow = math.floor(inflow)
  outflow = math.floor(outflow)

  flux_in.setFlowOverride(inflow)
  flux_out.setFlowOverride(outflow)

  -- Draw screen

  if term.isAvailable() then

    -- Draw Values

    local left_margin = 2
    local spacing = 2

    local values = {
      "Status:              " .. state,
      "Field Strength:      " .. ((info.fieldStrength / info.maxFieldStrength) * 100) .. "%",
      "Energy Saturation:   " .. ((info.energySaturation / info.maxEnergySaturation) * 100) .. "%",
      "Fuel Concentration:  " .. ((1 - info.fuelConversion / info.maxFuelConversion) * 100) .. "%",
      "Temperature:         " .. info.temperature .. " F",
      "Reactor Efficiency:  " .. info.fuelConversionRate .. " nb/t",
      "Energy Inflow Rate:  " .. inflow .. " RF/t",
      "Energy Outflow Rate: " .. outflow .. " RF/t"
    }

    if safe then
      values[#values+1] = "Click if flux gates need to be swapped"
    end

    term.clear()
    
    for i, v in ipairs(values) do
      term.setCursor(left_margin, i * spacing)
      term.write(v)
    end

    -- Draw button values

    term.setCursor(temp_adjust_x_offset, temp_adjust_y_offset+8)
    term.write("Target Temp: " .. ideal_temp .. " F")
    term.setCursor(field_adjust_x_offset, field_adjust_y_offset+8)
    term.write("Target Strength: " .. ideal_strength .. "%")

    -- Draw Buttons

    gpu.setForeground(0x000000)

    for bname, button in pairs(buttons) do
      if button.depressed then

        button.depressed = button.depressed - 1
        if button.depressed == 0 then
          button.depressed = nil
        end
      end
      if button.condition == nil or button.condition() then
        local center_color = 0xAAAAAA
        local highlight_color = 0xCCCCCC
        local lowlight_color = 0x808080
        if button.depressed then
          center_color = 0x999999
          highlight_color = 0x707070
          lowlight_color = 0xBBBBBB
        end
        gpu.setBackground(center_color)
        gpu.fill(button.x, button.y, button.width, button.height, " ")
        if button.width > 1 and button.height > 1 then
          gpu.setBackground(lowlight_color)
          gpu.fill(button.x+1, button.y+button.height-1, button.width-1, 1, " ")
          gpu.fill(button.x+button.width-1, button.y, 1, button.height, " ")
          gpu.setBackground(highlight_color)
          gpu.fill(button.x, button.y, 1, button.height, " ")
          gpu.fill(button.x, button.y, button.width, 1, " ")
        end
        gpu.setBackground(center_color)
        term.setCursor(button.x + math.floor(button.width / 2 - #button.text / 2), button.y + math.floor(button.height / 2))
        term.write(button.text)
      end
    end

    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
  end  

  -- Wait for next tick, or manual shutdown

  local event, id, op1, op2 = event.pull(0.05)
  if event == "interrupted" then
    if safe then
      break
    end
  elseif event == "touch" then
    
    -- Handle Button Presses

    local x = op1
    local y = op2

    for bname, button in pairs(buttons) do
      if (button.condition == nil or button.condition()) and x >= button.x and x <= button.x + button.width and y >= button.y and y <= button.y + button.height then
        button.action()
        button.depressed = 3
      end
    end
  end
end

term.clear()