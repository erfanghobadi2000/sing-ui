<template>
  <v-navigation-drawer
    v-model="showDrawer"
    :temporary="isMobile"
    :rail="!isMobile"
    :permanent="!isMobile"
    class="sing-ui-drawer"
    width="250"
    rail-width="82"
    elevation="0"
  >
    <div class="sing-ui-brand">
      <div class="sing-ui-brand-mark">S</div>
      <div v-if="isMobile" class="sing-ui-brand-copy">
        <strong>Sing-UI</strong>
        <span>Sing-Box Control Panel</span>
      </div>
      <div v-else class="sing-ui-brand-copy">
        <strong>Sing-UI</strong>
        <span>Sing-Box</span>
      </div>
    </div>

    <v-divider class="mx-4" />

    <v-list density="comfortable" nav class="sing-ui-nav">
      <v-list-item prepend-icon="mdi-view-dashboard-outline" :to="'/'" :active="$route.path === '/'">
        <v-list-item-title>Dashboard</v-list-item-title>
      </v-list-item>
      <v-list-item prepend-icon="mdi-lan-connect" :to="'/inbounds'">
        <v-list-item-title>Inbounds</v-list-item-title>
      </v-list-item>
      <v-list-item prepend-icon="mdi-account-multiple-outline" :to="'/clients'">
        <v-list-item-title>Clients</v-list-item-title>
      </v-list-item>
      <v-list-item prepend-icon="mdi-cloud-upload-outline" :to="'/outbounds'">
        <v-list-item-title>Outbounds</v-list-item-title>
      </v-list-item>
      <v-list-item prepend-icon="mdi-sitemap-outline" :to="'/rules'">
        <v-list-item-title>Routing</v-list-item-title>
      </v-list-item>
      <v-list-item prepend-icon="mdi-certificate-outline" :to="'/tls'">
        <v-list-item-title>TLS</v-list-item-title>
      </v-list-item>
      <v-list-item prepend-icon="mdi-dns-outline" :to="'/dns'">
        <v-list-item-title>DNS</v-list-item-title>
      </v-list-item>
      <v-list-item prepend-icon="mdi-server-outline" :to="'/services'">
        <v-list-item-title>Services</v-list-item-title>
      </v-list-item>
      <v-list-item prepend-icon="mdi-cog-outline" :to="'/settings'">
        <v-list-item-title>Settings</v-list-item-title>
      </v-list-item>
    </v-list>

    <template #append>
      <div class="sing-ui-drawer-footer">
        <v-btn
          block
          variant="text"
          prepend-icon="mdi-logout"
          @click="Logout"
        >
          <span>Logout</span>
        </v-btn>
      </div>
    </template>
  </v-navigation-drawer>
</template>

<script lang="ts" setup>
import { computed } from 'vue'
import { logout } from '@/plugins/httputil'

defineProps<{ isMobile: boolean, displayDrawer: boolean }>()
const emit = defineEmits<{ toggleDrawer: [] }>()

const showDrawer = computed({
  get: () => false,
  set: (v: boolean) => { if (!v) emit('toggleDrawer') },
})

const Logout = async () => {
  await logout()
}
</script>
