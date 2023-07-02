<template>
    <nav class="mt-6">
        <ul class="list-disc">
            <li>
                <Link href="/" class="text-blue-500 hover:underline"
                    :class="{ 'font-bold underline': $page.component === 'Home' }">
                Home
                </Link>
            </li>
            <li>
                <Link href="/users?foo=bar" class="text-blue-500 hover:underline"
                    :class="{ 'font-bold underline': $page.component === 'Users' }">
                Users
                </Link>
            </li>
            <li>
                <Link href="/settings" class="text-blue-500 hover:underline"
                    :class="{ 'font-bold underline': $page.component === 'Settings' }">Settings</Link>
            </li>
            <li>
                <Link href="/logout" method="POST" as="button" :data="{ foo: 'bar' }" class="text-blue-500 hover:underline"
                    :class="{ 'font-bold underline': $page.component === 'Logout' }">
                Logout
                </Link>
            </li>
        </ul>
    </nav>
</template>

<script>
import { Link } from '@inertiajs/vue3';

export default {
    components: { Link },
};
</script>

