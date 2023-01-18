# Miniview

<br>
<br>


## Example usage
`/src/routes/+layout.svelte`

```js 
import { navigating, page } from '$app/stores';

$: if($page) n($page)

function n(p){
    let n = $navigating

    if(typeof window !== 'undefined'){
        let msg = {
            from: n?.from.route.id || '', 
            to: n?.to.route.id || '',
            route: p.data,
            type: n?.type || 'initial'
        }
        if(window?.webkit?.messageHandlers?.myMessage){
            webkit.messageHandlers.myMessage.postMessage(msg)
        }      
    }
}

```

Then in your routes you can pass specific configurations. 
`src/routes/example/+page.js`

**Navbar with back chevron:**
```js
export async function load() {
    return {
        app: {
            type: 'plain',
            nav: {
                left: {
                    action: 'history.back()',
                    image: 'chevron-left.png',
                    title: ''
                }
            }
        }
    };
};
```

**Or for tabs:**

```js
export async function load() {
    return {
        app: {
            type: 'tabs',
            nav: {
                left: {
                    action: '',
                    image: 'chevron-left.png',
                    title: ''
                }
            },
            tabs: [
                {
                    title: '',
                    icon: 'icon.png',
                    url: 'home'
                },
                {
                    title: '',
                    icon: 'cog.png',
                    url: 'settings'
                }
            ]
        }
    }
}
```

<br>
<br>


## What's next 

There are a lot of things that can be improved and worked on especially on the Android side, and as I plan to use this myself for several projects I intend to do it as soon as possible. 

**Things like**
- Being able to handle a remote PWA to make the app also work in offline mode. 
- When opening modals a new WebView is created because it can't be shown in two places at once (but I think this can be solved with some creative ideas)
- Make sure theres a default view even if you don't pass anything from that specific route
- A well defined API for how things are defined. 
- On android the Back and Home functionality isn't good at all at the moment.
- Probably many more things :) but we are still very early here!              

<br>
<br>
<br>


## Be sure to try it and let me know what you think! 👍