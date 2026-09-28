<template>
  <v-app class="sing-ui-app">
    <drawer
      :is-mobile="isMobile"
      :display-drawer="displayDrawer"
      @toggle-drawer="toggleDrawer"
    />
    <default-bar
      :is-mobile="isMobile"
      @toggle-drawer="toggleDrawer"
    />
    <default-view />
  </v-app>
</template>

<script lang="ts" setup>
import { computed, ref, watch } from 'vue'
import DefaultBar from './AppBar.vue'
import Drawer from './Drawer.vue'
import DefaultView from './View.vue'
import { useDisplay } from 'vuetify'

const { smAndDown } = useDisplay()
const displayDrawer = ref(false)

const toggleDrawer = () => {
  displayDrawer.value = !displayDrawer.value
}

const isMobile = computed(() => smAndDown.value)
watch(smAndDown, (v) => { displayDrawer.value = !v }, { immediate: true })
</script>
