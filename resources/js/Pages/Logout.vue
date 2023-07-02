<template>
    <Layout>
        <h1 class="text-4xl font-bold">
            Loutout
        </h1>
    </Layout>
</template>

<script>
import Layout from "../Shared/Layout";

export default {
    components: { Layout },
    props: { time: String }
};
</script>
