# Token Lock

Lock ERC-20 token for a pre-defined amount of time

---

## Contract

A contract for locking balances of a designated ERC-20 token for a pre-defined amount of time.

1. **Deposit period:** Anyone can deposit the designated token, receiving an equivalent balance of non-transferrable lock claim token. Withdrawals are possible.
2. **Lock period:** No more deposits and withdrawals are possible.
3. **After the lock period:** Tokens can be withdrawn in redemption for lock claim tokens.

### Setup

#### Configuration

The contract is initialized with the following set of parameters:

- `owner`: Address of the owner
- `tokenAddress`: Address of the token to lock
- `unlockTimePoolOfMarket`: Lock of pool market duration in seconds, period starts after the deployment
- `unlockTimePoolOfEmployments`: Lock of pool employments duration in seconds, period starts after the deposit deadline

---

#### Getting Start

1. git clone https://github.com/chingunee/locked-pool.git

2. npm install

3. create a .env file, and copy and paste .env.template

4. npx hardhat compile

5. npx hardhat run scripts/deploy.js --network polygon

6. npx hardhat verify --network polygon contract-address 'param1' 'param2' 'param3' 'param4'

## License

Created under the [MIT license](LICENSE).
