import { createApp, h } from "vue";
import { createInertiaApp, Link } from "@inertiajs/vue3";
import DefaultLayout from "./Shared/Layout";

createInertiaApp({
    resolve: async (name) => {
        const { default: page } = await import(`./Pages/${name}.vue`);
        //Nếu component không có thuộc tính layout, chúng ta gán giá trị DefaultLayout (layout mặc định) cho nó.
        //Gán layout mặc định cho các trang không có layout Ở trong folder Pages
        if(!page.layout){
            page.layout = DefaultLayout;
        }
        return page;
    },
    setup({ el, App, props, plugin }) {
        createApp({ render: () => h(App, props) })
            .use(plugin)
            .component("Link", Link)
            .mount(el);
    },
});
