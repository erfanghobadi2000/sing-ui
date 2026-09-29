<template>
  <v-navigation-drawer v-model="showDrawer" :temporary="isMobile" :rail="!isMobile" :permanent="!isMobile" class="sing-ui-drawer" width="250" rail-width="82" elevation="0">
    <div class="sing-ui-brand">
      <div class="sing-ui-brand-mark">S</div>
      <div class="sing-ui-brand-copy">
        <strong>Sing-UI</strong>
        <span>{{ isMobile ? 'Sing-Box Control Panel' : 'Sing-Box' }}</span>
      </div>
    </div>
    <v-divider class="mx-4" />
    <v-list density="comfortable" nav class="sing-ui-nav">
      <v-list-item v-for="item in menu" :key="item.path" :prepend-icon="item.icon" :to="item.path">
        <v-list-item-title>{{ $t(item.title) }}</v-list-item-title>
      </v-list-item>
    </v-list>
    <template #append>
      <div class="sing-ui-drawer-footer">
        <v-btn block variant="text" prepend-icon="mdi-logout" @click="Logout">{{ $t('menu.logout') }}</v-btn>
      </div>
    </template>
  </v-navigation-drawer>
</template>

<script lang="ts" setup>
import { computed } from 'vue'
import { logout } from '@/plugins/httputil'

const props = defineProps<{ isMobile: boolean, displayDrawer: boolean }>()
const emit = defineEmits<{ toggleDrawer: [] }>()

const showDrawer = computed({
  get: () => props.displayDrawer,
  set: (v: boolean) => {
    if (props.isMobile && !v) emit('toggleDrawer')
  },
})

const menu = [
  { title: 'pages.home', icon: 'mdi-view-dashboard-outline', path: '/' },
  { title: 'pages.inbounds', icon: 'mdi-lan-connect', path: '/inbounds' },
  { title: 'pages.clients', icon: 'mdi-account-multiple-outline', path: '/clients' },
  { title: 'pages.outbounds', icon: 'mdi-cloud-upload-outline', path: '/outbounds' },
  { title: 'pages.rules', icon: 'mdi-sitemap-outline', path: '/rules' },
  { title: 'pages.tls', icon: 'mdi-certificate-outline', path: '/tls' },
  { title: 'pages.dns', icon: 'mdi-dns-outline', path: '/dns' },
  { title: 'pages.services', icon: 'mdi-server-outline', path: '/services' },
  { title: 'pages.settings', icon: 'mdi-cog-outline', path: '/settings' },
]

const Logout = async () => { await logout() }
</script>
