import { ethers } from "./ethers-6.7.esm.min.js"
import { abi, contractAddress } from "./constants.js"

// DOM Elements
const connectButton = document.getElementById("connectButton")
const withdrawButton = document.getElementById("withdrawButton")
const fundButton = document.getElementById("fundButton")
const balanceButton = document.getElementById("balanceButton")
const getOwnerButton = document.getElementById("getOwnerButton")
const getMinimumUsdButton = document.getElementById("getMinimumUsdButton")
const ethAmountInput = document.getElementById("ethAmount")
const connectionStatus = document.getElementById("connectionStatus")
const accountAddress = document.getElementById("accountAddress")
const contractBalance = document.getElementById("contractBalance")
const userContribution = document.getElementById("userContribution")
const ownerStatus = document.getElementById("ownerStatus")
const contractAddressDisplay = document.getElementById("contractAddressDisplay")
const notification = document.getElementById("notification")
const ethAmountError = document.getElementById("ethAmountError")

// Global state
let currentAccount = null
let provider = null
let signer = null
let contract = null

// Event listeners
connectButton.onclick = connect
withdrawButton.onclick = withdraw
fundButton.onclick = fund
balanceButton.onclick = getBalance
getOwnerButton.onclick = getOwner
getMinimumUsdButton.onclick = getMinimumUsd
ethAmountInput.oninput = validateEthAmount

// Initialize the app
window.addEventListener('load', async () => {
  contractAddressDisplay.textContent = contractAddress
  await checkConnection()
  
  // Listen for account changes
  if (window.ethereum) {
    window.ethereum.on('accountsChanged', handleAccountsChanged)
    window.ethereum.on('chainChanged', handleChainChanged)
  }
})

// Utility functions
function showNotification(message, type = 'info') {
  notification.textContent = message
  notification.className = `notification ${type} show`
  setTimeout(() => {
    notification.classList.remove('show')
  }, 5000)
}

function setButtonLoading(button, isLoading, originalText) {
  if (isLoading) {
    button.disabled = true
    button.innerHTML = `<span class="loading"></span>${originalText}...`
  } else {
    button.disabled = false
    button.innerHTML = originalText
  }
}

function formatAddress(address) {
  return `${address.slice(0, 6)}...${address.slice(-4)}`
}

function validateEthAmount() {
  const value = ethAmountInput.value
  const errorElement = ethAmountError
  
  if (!value) {
    errorElement.textContent = ""
    ethAmountInput.classList.remove('input-error')
    return true
  }
  
  if (isNaN(value) || parseFloat(value) <= 0) {
    errorElement.textContent = "Please enter a valid positive number"
    ethAmountInput.classList.add('input-error')
    return false
  }
  
  if (parseFloat(value) < 0.001) {
    errorElement.textContent = "Minimum amount is 0.001 ETH"
    ethAmountInput.classList.add('input-error')
    return false
  }
  
  errorElement.textContent = ""
  ethAmountInput.classList.remove('input-error')
  return true
}

async function checkConnection() {
  if (typeof window.ethereum !== "undefined") {
    try {
      const accounts = await ethereum.request({ method: "eth_accounts" })
      if (accounts.length > 0) {
        await setupConnection(accounts[0])
      }
    } catch (error) {
      console.error("Error checking connection:", error)
    }
  } else {
    connectionStatus.textContent = "MetaMask not detected"
    showNotification("Please install MetaMask to use this DApp", "error")
  }
}

async function setupConnection(account) {
  currentAccount = account
  provider = new ethers.BrowserProvider(window.ethereum)
  signer = await provider.getSigner()
  contract = new ethers.Contract(contractAddress, abi, signer)
  
  // Update UI
  connectionStatus.textContent = "Connected"
  accountAddress.textContent = formatAddress(account)
  connectButton.innerHTML = "✅ Connected"
  connectButton.classList.remove('btn-primary')
  connectButton.classList.add('btn-success')
  
  // Load initial data
  await Promise.all([
    getBalance(),
    getUserContribution(),
    checkOwnerStatus()
  ])
  
  showNotification(`Successfully connected to ${formatAddress(account)}`, "success")
}

function handleAccountsChanged(accounts) {
  if (accounts.length === 0) {
    // User disconnected
    currentAccount = null
    provider = null
    signer = null
    contract = null
    
    connectionStatus.textContent = "Not Connected"
    accountAddress.textContent = "-"
    contractBalance.textContent = "- ETH"
    userContribution.textContent = "- ETH"
    ownerStatus.textContent = "-"
    connectButton.innerHTML = "Connect Wallet"
    connectButton.classList.remove('btn-success')
    connectButton.classList.add('btn-primary')
    
    showNotification("Wallet disconnected", "info")
  } else if (accounts[0] !== currentAccount) {
    // User switched accounts
    setupConnection(accounts[0])
  }
}

function handleChainChanged(chainId) {
  // Reload the page to reset the state
  window.location.reload()
}

async function connect() {
  if (typeof window.ethereum !== "undefined") {
    try {
      setButtonLoading(connectButton, true, "Connecting")
      const accounts = await ethereum.request({ method: "eth_requestAccounts" })
      await setupConnection(accounts[0])
    } catch (error) {
      console.error("Connection error:", error)
      if (error.code === 4001) {
        showNotification("Connection rejected by user", "error")
      } else {
        showNotification("Failed to connect wallet", "error")
      }
    } finally {
      setButtonLoading(connectButton, false, "Connect Wallet")
    }
  } else {
    showNotification("Please install MetaMask", "error")
  }
}

async function withdraw() {
  if (!contract) {
    showNotification("Please connect your wallet first", "error")
    return
  }

  try {
    setButtonLoading(withdrawButton, true, "Checking permissions")
    
    // First check if the current user is the owner
    const owner = await contract.getOwner()
    const currentUserAddress = await signer.getAddress()
    
    if (owner.toLowerCase() !== currentUserAddress.toLowerCase()) {
      showNotification("❌ Only the contract owner can withdraw funds", "error")
      return
    }
    
    setButtonLoading(withdrawButton, true, "Withdrawing")
    showNotification("Initiating withdrawal transaction...", "info")
    
    const transactionResponse = await contract.cheaperWithdraw()
    showNotification("Transaction submitted! Waiting for confirmation...", "info")
    
    await transactionResponse.wait(1)
    showNotification("Withdrawal successful!", "success")
    
    // Refresh balances
    await Promise.all([
      getBalance(),
      getUserContribution(),
      checkOwnerStatus()
    ])
  } catch (error) {
    console.error("Withdrawal error:", error)
    console.error("Error details:", {
      message: error.message,
      reason: error.reason,
      code: error.code,
      data: error.data
    })
    
    if (error.code === 4001) {
      showNotification("Transaction rejected by user", "error")
    } else if (
      error.message.includes("FundMe__NotOwner") ||
      error.reason?.includes("FundMe__NotOwner") ||
      (error.data && error.data.includes && error.data.includes("FundMe__NotOwner")) ||
      error.message.includes("execution reverted") && error.message.includes("NotOwner")
    ) {
      showNotification("❌ Only the contract owner can withdraw funds", "error")
    } else if (error.message.includes("insufficient funds")) {
      showNotification("Insufficient funds for transaction", "error")
    } else if (error.message.includes("execution reverted")) {
      showNotification("Transaction reverted - you may not be the owner", "error")
    } else {
      showNotification(`Withdrawal failed: ${error.message}`, "error")
    }
  } finally {
    setButtonLoading(withdrawButton, false, "Withdraw Funds")
  }
}

async function fund() {
  if (!contract) {
    showNotification("Please connect your wallet first", "error")
    return
  }

  const ethAmount = ethAmountInput.value
  
  if (!validateEthAmount() || !ethAmount) {
    showNotification("Please enter a valid ETH amount", "error")
    return
  }

  try {
    setButtonLoading(fundButton, true, "Funding")
    showNotification(`Initiating funding transaction for ${ethAmount} ETH...`, "info")
    
    const transactionResponse = await contract.fund({
      value: ethers.parseEther(ethAmount),
    })
    
    showNotification("Transaction submitted! Waiting for confirmation...", "info")
    await transactionResponse.wait(1)
    
    showNotification(`Successfully funded ${ethAmount} ETH!`, "success")
    
    // Clear input and refresh balances
    ethAmountInput.value = ""
    await Promise.all([
      getBalance(),
      getUserContribution(),
      checkOwnerStatus()
    ])
  } catch (error) {
    console.error("Funding error:", error)
    
    if (error.code === 4001) {
      showNotification("Transaction rejected by user", "error")
    } else if (error.message.includes("insufficient funds")) {
      showNotification("Insufficient ETH balance", "error")
    } else if (error.message.includes("You need to spend more ETH")) {
      showNotification("Amount below minimum funding requirement", "error")
    } else {
      showNotification(`Funding failed: ${error.message}`, "error")
    }
  } finally {
    setButtonLoading(fundButton, false, "Fund Contract")
  }
}

async function getBalance() {
  if (!provider) {
    showNotification("Please connect your wallet first", "error")
    return
  }

  try {
    setButtonLoading(balanceButton, true, "Loading")
    const balance = await provider.getBalance(contractAddress)
    const balanceInEth = ethers.formatEther(balance)
    contractBalance.textContent = `${parseFloat(balanceInEth).toFixed(4)} ETH`
  } catch (error) {
    console.error("Balance fetch error:", error)
    showNotification("Failed to fetch contract balance", "error")
    contractBalance.textContent = "Error"
  } finally {
    setButtonLoading(balanceButton, false, "Refresh Balance")
  }
}

async function getUserContribution() {
  if (!contract || !currentAccount) {
    return
  }

  try {
    const contribution = await contract.getAddressToAmountFunded(currentAccount)
    const contributionInEth = ethers.formatEther(contribution)
    userContribution.textContent = `${parseFloat(contributionInEth).toFixed(4)} ETH`
  } catch (error) {
    console.error("User contribution fetch error:", error)
    userContribution.textContent = "Error"
  }
}

async function checkOwnerStatus() {
  if (!contract || !currentAccount) {
    return
  }

  try {
    const owner = await contract.getOwner()
    const isOwner = owner.toLowerCase() === currentAccount.toLowerCase()
    
    if (isOwner) {
      ownerStatus.textContent = "✅ Owner"
      ownerStatus.style.color = "#28a745"
    } else {
      ownerStatus.textContent = "❌ Not Owner"
      ownerStatus.style.color = "#dc3545"
    }
  } catch (error) {
    console.error("Owner status check error:", error)
    ownerStatus.textContent = "Error"
  }
}

async function getOwner() {
  if (!contract) {
    showNotification("Please connect your wallet first", "error")
    return
  }

  try {
    setButtonLoading(getOwnerButton, true, "Loading")
    const owner = await contract.getOwner()
    showNotification(`Contract Owner: ${formatAddress(owner)}`, "info")
  } catch (error) {
    console.error("Get owner error:", error)
    showNotification("Failed to fetch contract owner", "error")
  } finally {
    setButtonLoading(getOwnerButton, false, "Get Owner")
  }
}

async function getMinimumUsd() {
  if (!contract) {
    showNotification("Please connect your wallet first", "error")
    return
  }

  try {
    setButtonLoading(getMinimumUsdButton, true, "Loading")
    const minimumUsd = await contract.MINIMUM_USD()
    const minimumUsdFormatted = ethers.formatUnits(minimumUsd, 18)
    showNotification(`Minimum funding amount: $${minimumUsdFormatted} USD`, "info")
  } catch (error) {
    console.error("Get minimum USD error:", error)
    showNotification("Failed to fetch minimum USD amount", "error")
  } finally {
    setButtonLoading(getMinimumUsdButton, false, "Get Minimum USD")
  }
}
