<template>
    <h1 class="text-4xl font-bold">
        Users
    </h1>

    <div style="margin-top: 1400px">
        <p>The current time is {{ time }}.</p>

        <Link href="/users" class="text-blue-500" preserve-scroll>
        Refresh
        </Link>
    </div>
</template>

<script>
export default {
    props: { time: String }
};
</script>
