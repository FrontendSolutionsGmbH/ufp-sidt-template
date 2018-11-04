import './styles/main.scss'
import UfpCore from 'ufp-core'
import {ConfigRunfest, registerConfigDefault} from 'ufp-core/lib/modules/config'
// @if UFP_NODE_ENV='production'
console.log('UFP Env UFP_VERSION /* @echo UFP_VERSION */')
console.log('UFP Env UFP_THEME /* @echo UFP_THEME */')
console.log('UFP Env UFP_API_TYPE /* @echo UFP_API_TYPE */')
console.log('UFP Env UFP_NODE_ENV /* @echo UFP_NODE_ENV */')
console.log('ARBITRARY ENV VAR /* @echo MY_ENV_VAR */')
// @endif
registerConfigDefault({foo: 'bar'})
registerConfigDefault({bar: 'foo'})

UfpCore.registerRunfest(ConfigRunfest)

UfpCore.startupUfpCore({applicationName: 'Minimal Null'})

ConfigRunfest.setConfigValue({
    key: 'bar',
    value: 'willi'
})

console.log('hulsussss')

ConfigRunfest.setConfigValue({
    key: 'hoschi',
    value: 'willi'
})
console.log('DEMO Retrieve Config', ConfigRunfest.getConfigValue({key: 'bar'}))
