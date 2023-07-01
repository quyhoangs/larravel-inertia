<template>
    <div>
        <h1>Welcome , {{ name }}</h1>
    </div>

    <div>
        <h2>Framework</h2>
        <ul>
            <li v-for="framework of frameworks" v-text="framework"></li>
        </ul>
    </div>
</template>


<script>
export default {
    props: {
        name: String,
        frameworks: Array,
    },
}
</script>
