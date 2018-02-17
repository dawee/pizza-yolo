local inspect = require('test.lib.inspect')
local ansicolors = require('test.lib.ansicolors')

local state = {
  suites = {}
}

-- Assertions

local assert = {}

function assert.is(actual, expected)
  if not (actual == expected) then
    return {pass = false, message = 'expected ' ..
      inspect(actual) ..
      ' to equal ' ..
      inspect(expected)}
  end

  return {pass = true}
end

function assert.all(...)
  local results = {...}

  for key, result in pairs(results) do
    if not result.pass then
      return result
    end
  end

  return {pass = true}
end

-- Utils

local function it(description)
  local t = {description = description}

  return t
end

local function formatResult(description, color, result, message)
  local inspectedMessage = message and not (type(message) == 'string') and inspect(message) or message
  local formatedMessage = message and '\n    ' .. inspectedMessage or ''

  print(
    '  ' ..
    ansicolors.bright ..
    description ..
    ansicolors.reset ..
    ' -> ' ..
    color ..
    result ..
    ansicolors.reset ..
    formatedMessage
  )
end

local function runTest(test)
  local error = nil

  local function saveError(spawnedError)
    error = spawnedError .. debug.traceback()
  end

  local function tryRun()
    return test.run(assert)
  end

  if test.run then
    local status, result = xpcall(tryRun, saveError)

    if error then
      formatResult(test.description, ansicolors.red, 'error', error)
    elseif result.pass then
      formatResult(test.description, ansicolors.green, 'pass')
    else
      formatResult(test.description, ansicolors.red, 'fail', result.message)
    end
  else
    formatResult(test.description, ansicolors.cyan, 'pending')
  end

end

-- Latte

local latte = {}

function latte.describe(name)
  local suite = {name = name, tests = {}}

  return suite, suite.tests
end

function love.update()
  if #state.suites > 0 then
    local suite = state.suites[1]

    if #suite.tests > 0 then
      if not suite.started then
        suite.started = true
        print(ansicolors.bright .. suite.name .. ansicolors.reset)
      end

      runTest(suite.tests[1])

      table.remove(suite.tests, 1)
    end

    if #suite.tests == 0 then
      table.remove(state.suites, 1)
    end
  else
    love.event.quit()
  end
end

local function addSuite(suite, pattern)
  local packedSuite = {name = suite.name, tests = {}}

  for name, newTest in pairs(suite.tests) do
    local test, run = newTest(it)

    if (not pattern) or string.find(test.description, pattern) then
      packedSuite.tests[#packedSuite.tests + 1] = {
        description = test.description,
        run = run,
        started = false
      }
    end
  end

  state.suites[#state.suites + 1] = packedSuite
end

function latte.run(suitesRoot, args)
  local suites = require(suitesRoot)

  for name, suite in pairs(suites) do
    addSuite(suite, args[1])
  end
end

return latte
